import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';

class AddAddress extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cState = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key:scaffoldKey,
      appBar:MyAppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(onPressed: ()
      {
         if(formKey.currentState.validate())
         {
           final model = AddressModel(
             name:cName.text.trim(),
             state:cState.text.trim(),
             phoneNumber: cPhoneNumber.text,
             flatNumber: cFlatHomeNumber.text,
           ).toJson();
           //add to firestore
           EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
           .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
           .collection(EcommerceApp.subCollectionAddress)
           .document(DateTime.now().millisecondsSinceEpoch.toString())
           .setData(model)
           .then((value){
             final snack = SnackBar(content:Text("New address added successfully."));
             scaffoldKey.currentState.showSnackBar(snack);
             FocusScope.of(context).requestFocus(FocusNode());
             formKey.currentState.reset();
           });
           Route route = MaterialPageRoute(builder:(c)=>StoreHome());
           Navigator.pushReplacement(context, route);
         }
      }, label: Text("Done"),
      backgroundColor: Colors.cyan,
      icon:Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child:Text("Add new address",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight:FontWeight.bold,
                  fontSize: 20.0
                  ),
                  )
              ),
            ),
            Form(
              key:formKey,
              child:Column(
                children: [
                MyTextField(
                  hint:"Name",
                  controller:cName,
                ), MyTextField(
                  hint:"Phone Number",
                  controller:cPhoneNumber,
                ),
                 MyTextField(
                  hint:"Home Number",
                  controller:cFlatHomeNumber,
                ),

                 MyTextField(
                  hint:"Address",
                  controller:cState,
                ),
                ],
              )
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {

 final String hint;
 final TextEditingController controller;

 MyTextField({Key key,this.hint, this.controller}): super(key:key);


  @override
  Widget build(BuildContext context) {
    return Padding(
     padding:EdgeInsets.all(8.0),
     child: TextFormField(
       controller: controller,
       decoration:InputDecoration.collapsed(hintText:hint),
       validator:(val)=>val.isEmpty ? " field can't be empty" : null,
     ),
    );
  }
}
