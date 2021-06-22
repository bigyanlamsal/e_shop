import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:e_shop/Config/config.dart';


class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //App Bar Image and title
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Image(
          image: AssetImage('images/background1.jpg'),
          fit:BoxFit.cover,
          
        ),
        title: Text(
          "mero pasal",
          style: TextStyle(fontSize:55.0,
           color:Colors.white,
          fontFamily: "Signatra"
          ),
        ),
        centerTitle: true,
          // Login and Register tabs
        bottom:TabBar(
          tabs: [
            Tab(
              icon:Icon(
                Icons.lock_outlined,
                color: Colors.white,),
                text:"Login",
              ),
              Tab(
              icon:Icon(
                Icons.perm_contact_cal_outlined,
                color: Colors.white,),
                text:"Register",
              )
            
          ],
         //-----Indicator between tabs
         indicatorColor:Colors.white30,
         indicatorWeight: 5.0,

        )
         ),

         //Body images addition
          body: Container
          (
        decoration:BoxDecoration(
        image:DecorationImage(
        image: AssetImage('images/background1.jpg'),
         fit: BoxFit.cover,
         ),
        ),
      
      //calling register and login pages

      child: TabBarView(
        children: [
          Login(),
          Register(),
        ],
      ),

      )
      )
      );
}
}