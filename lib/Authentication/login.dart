import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  double _screenWidth =MediaQuery.of(context).size.width, 
  _screenHeight = MediaQuery.of(context).size.height;
   return SingleChildScrollView(
     child: Container(
       child: Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             alignment: Alignment.bottomCenter,
             child:GestureDetector(

            // *******--------On long Tap redirect to admin login page---**********

               onLongPressUp: ()=>Navigator.push
             (
               context, MaterialPageRoute(
                 builder: (context)=>AdminSignInPage()
                 )
                 ),
              
               
             child: Image.asset(
               "images/login.png",
               height:200.0,
               width:200.0 ,
             )
             )
           ),
           Padding(
             padding: EdgeInsets.all(8.0),
             child: Text(
               "Login to your account",
               style:TextStyle(color: Colors.white) ,
             )
             ),

             // form for login page

             Form(
           key:_formKey ,
           child: Column(
            children: [

              CustomTextField(
                controller: _emailTextEditingController ,
                data: Icons.mail_outline,
                hintText: "E-mail",
                isObsecure: false,
              ),

              CustomTextField(
                controller: _passwordTextEditingController ,
                data: Icons.remove_red_eye,
                hintText: "Password",
                isObsecure: true,
              ), 
            ], 
           ),
           ),
             
          // login form ends here

         //----------------Login button -------------

          new SizedBox(
             width: 100.0,
             height:50.0,
             child:
          new RaisedButton(onPressed: () {
            _emailTextEditingController.text.isNotEmpty
            && _passwordTextEditingController.text.isNotEmpty
            ? loginUser()
            :showDialog(context: context,
            builder:(c)
            {
              return ErrorAlertDialog(message: "Please enter email and password",);
            });
          },
           color: Colors.cyan.withOpacity(0.4),
           child:Text("Login",style:TextStyle(color:Colors.white),
           )
           ),
           ),
         
         Divider(color:Colors.white),

         Text("Happy Shopping",style:TextStyle(color:Colors.white30,fontSize: 30.0,fontFamily: "CrimsonText-Regular",),)

         ]
       ),
       ),   
       );
  }


  FirebaseAuth _auth = FirebaseAuth.instance;

 void loginUser() async
  {
   showDialog(context: context,
   builder:(c)
   {
     return LoadingAlertDialog(message: "Authenticating, Please wait......",);
   }
   );

   FirebaseUser firebaseUser;
   await _auth.signInWithEmailAndPassword(
    email: _emailTextEditingController.text.trim(),
    password: _passwordTextEditingController.text.trim(),
   ).then((authUser){
     firebaseUser = authUser.user;
   }).catchError((error){
     Navigator.pop(context);
       showDialog(context: context,
       builder: (c)
       {
         return ErrorAlertDialog(message:error.message.toString(),);
       }
       );
   });
   if (firebaseUser != null)
   {
     readData(firebaseUser).then((s){
        Navigator.pop(context);
         Route route = MaterialPageRoute(builder: (c)
         => StoreHome());
         Navigator.pushReplacement(context,route);
     });
   }
  }

 Future readData(FirebaseUser fUser) async
 {
 Firestore.instance.collection("users").document(fUser.uid).get().then((dataSnapshot)
 async{
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID,dataSnapshot.data[EcommerceApp.userUID]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,dataSnapshot.data[EcommerceApp.userEmail]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,dataSnapshot.data[EcommerceApp.userName]);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,dataSnapshot.data[EcommerceApp.userAvatarUrl]);

    List<String> cartList = dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,cartList);
 });
 }

}
