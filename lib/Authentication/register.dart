import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';



class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
   double _screenWidth =MediaQuery.of(context).size.width, 
   _screenHeight = MediaQuery.of(context).size.height;
   return SingleChildScrollView(
     child: Container(
       child: Column
       (
         mainAxisSize: MainAxisSize.max ,
         children: [
           SizedBox(height: 10.0,),
           InkWell(
             onTap: _selectAndPickImage,
             child:CircleAvatar(
               radius:_screenWidth*0.15 ,
               backgroundColor: Colors.white.withOpacity(0.5),
               backgroundImage: _imageFile==null ? null: FileImage(_imageFile),
               child: _imageFile == null ? 
               Icon(Icons.add_a_photo_outlined,
               size:_screenWidth*0.15,
               color:Colors.grey)
               :null,)
           ),
         SizedBox(height:8.0,),

       // form for register page 

         Form(
           key:_formKey ,
           child: Column(
            children: [
              CustomTextField(
                controller: _nameTextEditingController ,
                data: Icons.person_outline,
                hintText: "Name",
                isObsecure: false,
              ),

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

              CustomTextField(
                controller: _cPasswordTextEditingController ,
                data: Icons.remove_red_eye_outlined,
                hintText: "Confirm Password",
                isObsecure: true,

              )
            ], 
           ),
           ),

         //-------Register Button
 
           new SizedBox(
             width: 100.0,
             height:50.0,
             child:
             new RaisedButton(onPressed: () {uploadAndSaveImage();},
           color: Colors.cyan.withOpacity(0.4),
           child:Text("Register",style:TextStyle(color:Colors.white),
           )
           ),
           ),
         
         Divider(color:Colors.white),

         // message to users

         Text("💖Welcome💖",style:TextStyle(color:Colors.white30,fontSize: 30.0,fontFamily: "CrimsonText-Regular",),)
         ],
       ),
       ),
   );
  }


 Future<void> _selectAndPickImage() async
  {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadAndSaveImage() async
  {
    if(_imageFile == null)
    {
      showDialog(context: context,
      builder: (c)
      {
      return ErrorAlertDialog(message: "Please upload image",);
      }
      );
    }
    else{
      _passwordTextEditingController.text == _cPasswordTextEditingController.text
      ? _emailTextEditingController.text.isNotEmpty
      && _nameTextEditingController.text.isNotEmpty 
      && _passwordTextEditingController.text.isNotEmpty
      && _cPasswordTextEditingController.text.isNotEmpty
      
      ? uploadToStorage()
      :displayDialog("Please fill up carefully.")
      :displayDialog("password do not match");
    }
  }

    displayDialog(String msg)
    {
      showDialog(context: context,
      builder:(c)
      {
        return ErrorAlertDialog(message:msg,);
      }
      );
    }
  uploadToStorage() async{
    showDialog(context: context,
    builder:(c)
    {
     return LoadingAlertDialog(message: 'authenticating please wait...',);
    }
    );
   String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

   StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);

   StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

   StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

   await taskSnapshot.ref.getDownloadURL().then((urlImage){
    userImageUrl = urlImage;

    _registerUser();
   });
  }
  
  //register user
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth.createUserWithEmailAndPassword(
     email: _emailTextEditingController.text.trim(),
     password: _passwordTextEditingController.text.trim(),
     ).then((auth){
      firebaseUser = auth.user;
     }).catchError((error){
       Navigator.pop(context);
       showDialog(context: context,
       builder: (c)
       {
         return ErrorAlertDialog(message:error.message.toString(),);
       }
       );
     });

     if(firebaseUser != null)
     {
       saveUserInfoToFireStore(firebaseUser).then((value){
         Navigator.pop(context);
         Route route = MaterialPageRoute(builder: (c)
         => StoreHome());
         Navigator.pushReplacement(context,route);
       });
     }
  }
   
  Future saveUserInfoToFireStore(FirebaseUser fUser) async
  {
    Firestore.instance.collection("users").document(fUser.uid).setData({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });

    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userUID,fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail,fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName,_nameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"]);

  }

}