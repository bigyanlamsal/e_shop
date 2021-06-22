import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Counters/ItemQuantity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers:
      [
      ChangeNotifierProvider(create: (c)=> CartItemCounter()),
      ChangeNotifierProvider(create: (c)=> ItemQuantity()),
      ChangeNotifierProvider(create: (c)=> AddressChanger()),
      ChangeNotifierProvider(create: (c)=> TotalAmount()),
       ],
    
        child:MaterialApp(
            title: 'e-Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green,
            ),
            home: SplashScreen()
    ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>
{

  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  //----If user is already logged in or not -------

  displaySplash(){
    Timer(Duration(seconds:5),() async {
      if(await EcommerceApp.auth.currentUser() != null)
      {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      }
      else
      {
       Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
        Image.asset('images/background1.jpg',
         fit: BoxFit.cover,
         width: double.infinity,
         height: double.infinity,
         ),
        
        Container(
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Image.asset("images/CartLogo.png"),
               SizedBox(height: 40.0,
               width: 40.0,),
               Text(
                 "Welcome To Mero Pasal..Best Recognizes Best",
               style:TextStyle(color:Colors.white,
                      fontFamily: "Amagh_Demo",
                      fontSize: 30.0),
               )
             ],
           ),
           ),
        ),
        ],
      )
    );
  }
}
