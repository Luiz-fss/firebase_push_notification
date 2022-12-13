import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var a = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final status = await FirebaseMessaging.instance.requestPermission();
  if( status.authorizationStatus == AuthorizationStatus.authorized){}

  final checarStats =  await FirebaseMessaging.instance.getNotificationSettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<void> onBackgroungMessage(RemoteMessage message)async{

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeFcm();
  }

  Future<void> initializeFcm()async{
    //Registro no firebase
    final token = await messaging.getToken(
      vapidKey: "BCxPfIPPZfv4N7Y6JdKbzM4EHzUykr8PK1OGKXA-K9hyOMon3AKA_-p28eoWzTsyuSsRIskguxeuMMILEcnVnHI"
    );
    print(token);
    if(!kIsWeb){
      messaging.subscribeToTopic("corinthians");
    }

    FirebaseMessaging.onMessage.listen((event) {
      if(event.notification!=null){
        Flushbar(
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          title: event.notification?.title,
          message: event.notification?.body,
          duration: Duration(seconds: 3),
        ).show(context);
      }
      print(event.data);
      print("mensagem recebida" + event.notification?.title);
    });
    
    FirebaseMessaging.onBackgroundMessage(onBackgroungMessage);
    //Monitora em background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event.notification.title);
    });

    /*Tras mensagem inicial que tenha recebido caso tenha acabado de abrir
    * o aplicativo*/
    final RemoteMessage mensagemTerminated = await messaging.getInitialMessage();
    if(mensagemTerminated!=null){
      print("toque com app em estado terminated : ${mensagemTerminated.notification.title}");
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
