import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum VoiceRecordingState {
  idle,
  recording,
  completed,
}

class VoiceAssessmentViewModel extends ChangeNotifier {
  late final AudioRecorder _recorder;
  late final AudioPlayer _player;

  VoiceRecordingState _recordingState = VoiceRecordingState.idle;
  VoiceRecordingState get recordingState => _recordingState;

  int _recordingSeconds = 0;
  int get recordingSeconds => _recordingSeconds;

  Timer? _recordingTimer;
  String? _recordedAudioPath;
  String? get recordedAudioPath => _recordedAudioPath;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Duration _playPosition = Duration.zero;
  Duration get playPosition => _playPosition;

  Duration _totalDuration = const Duration(seconds: 2);
  Duration get totalDuration => _totalDuration;

  StreamSubscription? _playerCompleteSub;
  StreamSubscription? _playerPositionSub;
  StreamSubscription? _playerDurationSub;

  VoiceAssessmentViewModel() {
    _recorder = AudioRecorder();
    _player = AudioPlayer();

    _playerCompleteSub = _player.onPlayerComplete.listen((_) {
      _isPlaying = false;
      _playPosition = Duration.zero;
      notifyListeners();
    });

    _playerPositionSub = _player.onPositionChanged.listen((pos) {
      _playPosition = pos;
      notifyListeners();
    });

    _playerDurationSub = _player.onDurationChanged.listen((dur) {
      _totalDuration = dur;
      notifyListeners();
    });
  }

  Future<void> startRecording() async {
    try {
      final bool hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        debugPrint('[Fluentio] Mic permission not granted.');
      }

      String? filePath;
      if (!kIsWeb) {
        final tempDir = await getTemporaryDirectory();
        filePath = '${tempDir.path}/fluentio_speech_${DateTime.now().millisecondsSinceEpoch}.m4a';
      }

      _recordingSeconds = 0;
      _recordingState = VoiceRecordingState.recording;
      notifyListeners();

      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _recordingSeconds++;
        notifyListeners();
        if (_recordingSeconds >= 60) {
          stopRecording();
        }
      });

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath ?? '',
      );
    } catch (e) {
      debugPrint('[Fluentio] Error starting audio recorder: $e');
    }
  }

  Future<void> stopRecording() async {
    _recordingTimer?.cancel();

    try {
      final path = await _recorder.stop();
      _recordedAudioPath = path;
      debugPrint('[Fluentio] Audio recorded successfully at: $_recordedAudioPath');
    } catch (e) {
      debugPrint('[Fluentio] Error stopping audio recorder: $e');
    }

    _recordingState = VoiceRecordingState.completed;
    notifyListeners();
  }

  Future<void> togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
      notifyListeners();
    } else {
      if (_recordedAudioPath != null && _recordedAudioPath!.isNotEmpty) {
        await _player.play(DeviceFileSource(_recordedAudioPath!));
        _isPlaying = true;
        notifyListeners();
      }
    }
  }

  void reRecord() {
    _player.stop();
    _isPlaying = false;
    _recordingSeconds = 0;
    _recordingState = VoiceRecordingState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _playerCompleteSub?.cancel();
    _playerPositionSub?.cancel();
    _playerDurationSub?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }
}
