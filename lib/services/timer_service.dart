import 'dart:async';
import 'dart:isolate';

class SleepTimerService {
  Function intervalFunc, doneFunc;
  Duration timerDuration;
  Isolate _isolate;
  bool running = false;
  static int _counter = 0;
  ReceivePort _receivePort;

  SleepTimerService(Function func1, Function func2, Duration duration){
    intervalFunc = func1;
    doneFunc = func2;
    timerDuration = duration;
  }

  void start() async {
    print('Starting timer service. Duration: $timerDuration');
    running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleIntervalCallback, onDone:() {
      print("done!");
      doneFunc();
    });
  }

   static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) {
      _counter++;
      sendPort.send(_counter);
    });
  }

  void _handleIntervalCallback(dynamic data) {
    print('RECEIVED: ' + data.toString());
    if(timerDuration.inSeconds==data){
      stop();
    }else{
      intervalFunc(data);
    }
  }

  void stop() {
    if (_isolate != null) {
      running = false;
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }
}