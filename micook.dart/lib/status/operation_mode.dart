enum OperationMode {
  error,
  finish,
  offline,
  pause,
  pauseTime,
  precook,
  running,
  setClock,
  setStartTime,
  setCookingTime,
  shutdown,
  timing,
  waiting
}

extension OperationModeExtension on OperationMode {
  static OperationMode fromString(String value) {
    switch (value) {
      case 'error':
        return OperationMode.error;
      case 'finish':
        return OperationMode.finish;
      case 'offline':
        return OperationMode.offline;
      case 'pause':
        return OperationMode.pause;
      case 'pause_time':
        return OperationMode.pauseTime;
      case 'precook':
        return OperationMode.precook;
      case 'running':
        return OperationMode.running;
      case 'set01':
        return OperationMode.setClock;
      case 'set02':
        return OperationMode.setStartTime;
      case 'set03':
        return OperationMode.setCookingTime;
      case 'shutdown':
        return OperationMode.shutdown;
      case 'timing':
        return OperationMode.timing;
      case 'waiting':
        return OperationMode.waiting;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }
}
