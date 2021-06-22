import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:flutter/material.dart';




class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Image(
          image: AssetImage('images/background1.jpg'),
          fit:BoxFit.cover, 
        ),
        title:Text(
          "Administrator",
          style:TextStyle(fontSize: 25.0,
          color:Colors.white,
          fontFamily: "CrimsonText-SemiBold"
        ),
        ),
        centerTitle: true,
    ),
    body:AdminSignInScreen(),
    );
  }
}


class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen>
{
  final TextEditingController _adminIDTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double _screenWidth =MediaQuery.of(context).size.width, 
   _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
     child: Container(
       decoration: new BoxDecoration(
         image:DecorationImage(
          image: AssetImage('images/background1.jpg'),
          fit:BoxFit.cover, 
        ),
       ),
       
       child: Column(
         mainAxisSize: MainAxisSize.max,
         children: [
           Container(
             alignment: Alignment.bottomCenter,
               
             child: Image.asset(
               "images/admin.png",
               height:200.0,
               width:200.0 ,
             )
             ),
           
           Padding(
             padding: EdgeInsets.all(8.0),
             child: Text(
               "Admin",
               style:TextStyle(color: Colors.white,fontSize: 28.0) ,
             )
             ),

             // form for login page

             Form(
           key:_formKey ,
           child: Column(
            children: [

              CustomTextField(
                controller: _adminIDTextEditingController ,
                data: Icons.person_outline,
                hintText: "Admin ID",
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
            _adminIDTextEditingController.text.isNotEmpty
            && _passwordTextEditingController.text.isNotEmpty
            ? loginAdmin()
            :showDialog(context: context,
            builder:(c)
            {
              return ErrorAlertDialog(message: "Please enter Admin ID and Password",);
            });
          },
           color: Colors.cyan.withOpacity(0.4),
           child:Text("Login",style:TextStyle(color:Colors.white),
           )
           ),
           ),

          SizedBox(
         height: 15.0,
         ),

         Divider(color:Colors.white),

         SizedBox(
         height: 15.0,
         ),

         RaisedButton.icon(onPressed:()=>
         Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthenticScreen())),
         icon: (
           Icon(Icons.nature_people, color:Colors.black)
           ),
           color: Colors.cyan.withOpacity(0.4),
         label: Text(
           "Not A Admin",style: TextStyle(color:Colors.white,fontWeight:FontWeight.bold),
         ),
         ),
         SizedBox(
           height:72.0
         )

         //Text("",style:TextStyle(color:Colors.white30,fontSize: 30.0,fontFamily: "CrimsonText-Regular",),)

         ]
       ),
       ),   
       );
  }

  loginAdmin()
  {
    Firestore.instance.collection("admins").getDocuments().then((snapshot){
      snapshot.documents.forEach((result) 
      {
        if(result.data["id"]!=_adminIDTextEditingController.text.trim())
        {
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your valid identity"),));
        }
        else if(result.data["password"]!=_passwordTextEditingController.text.trim())
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Please enter your valid password"),));


      
        else{
         Scaffold.of(context).showSnackBar(SnackBar(content: Text("Service is our great responsibility Dear," + result.data["name"]),));
        
        setState(() {
          _adminIDTextEditingController.text = "";
          _passwordTextEditingController.text =" ";
        });
        
        Route route = MaterialPageRoute(builder: (c)
         => UploadPage());
         Navigator.pushReplacement(context,route);
        }

       });
    });
  }
}
