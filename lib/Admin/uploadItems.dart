import 'dart:io';
//import 'dart:js_util';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_shop/Authentication/authenication.dart';
import 'package:image/image.dart' as ImD;


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =TextEditingController();
  TextEditingController _titleTextEditingController =TextEditingController();
  TextEditingController _priceTextEditingController =TextEditingController();
  TextEditingController _shortInfoTextEditingController =TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file ==null ?  displayAdminHomeScreen()  :  
    displayAdminUploadScreen();
  }

  displayAdminHomeScreen()
  {
    return Scaffold ( 
      appBar: AppBar(
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
        leading: IconButton(
          icon:Icon(Icons.border_color,color: Colors.white,),
          onPressed: (){
            Route route = MaterialPageRoute(builder: (c)=>AdminShiftOrders());
            Navigator.pushReplacement(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text("LogOut",
            style: TextStyle(
              color:Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            ),
            onPressed: ()
            {
                 Route route = MaterialPageRoute(builder: (c)
                  => AuthenticScreen());
                  Navigator.pushReplacement(context,route);  
            },
          )
        ],
      ),
      body:getAdminHomeScreenBody(),

    );
  }

  getAdminHomeScreenBody()
  {
    return Container(
    decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("images/background1.jpg"),
          fit: BoxFit.fill,
          ) 
          ),
          child:Center(child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shop_two_outlined,
              color:Colors.white,
              size:200.0
              ),
              Padding(
                padding: EdgeInsets.only(top:20.0),
                child: RaisedButton(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                    child: Text("Add New Items",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                 color: Colors.lightBlue,
                  onPressed: ()=>takeImage(context),
                  ),
                ),
            ],
          ),
          )
    );
  }
  takeImage(mContext){
   return showDialog(
     context: mContext,
     builder: (con)
     {
       return SimpleDialog
       (
         
         title:Text("Add Image Of A Product",
         style:TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.bold,
         ),
       ),
        
        children: [
          SimpleDialogOption(
            child:Text("Capture With Camera",
            style:TextStyle(color: Colors.black)),
            onPressed: capturePhotoWithCamera,
          ),
           SimpleDialogOption(
            child:Text("Select from gallery",
            style:TextStyle(color: Colors.black)),
            onPressed: pickPhotoFromGallery,
           ),
            SimpleDialogOption(
            child:Text("Cancel",
            style:TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
            
            onPressed: (){
              Navigator.pop(context);
            },
            
            )
        ],

       backgroundColor: Colors.cyan,
        
   );
     }
   );
  }

  capturePhotoWithCamera() async
  {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage
    (
      source: ImageSource.camera,
      maxHeight:680.0,
      maxWidth:970.0
      );
      setState(() {
        file = imageFile;
      });
  }
 
  pickPhotoFromGallery() async
  {
   Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage
    (
      source: ImageSource.gallery,
      );

      setState(() {
        file = imageFile;
      }); 
  }

  displayAdminUploadScreen(){
    return Scaffold(
    appBar: AppBar(
    flexibleSpace: Image(
          image: AssetImage('images/background1.jpg'),
          fit:BoxFit.cover, 
        ),
        leading: IconButton(
          icon:Icon(Icons.arrow_back,color:Colors.white
          ),
          onPressed: clearFormInfo),
          title:Text("New Product",
          style: TextStyle(color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold),
          ),
          actions: [
            FlatButton(
              onPressed:uploading ? null : ( )=>uploadImageAndSaveItemInfo(),
              child: Text("Add",style:TextStyle(color:Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold)),
            ),
          ],
         ),
         body: ListView
         (
          children: [
            uploading ? circularProgress() : Text (""),
            Container(
              height:230.0,
              width: MediaQuery.of(context).size.width*0.8,
              child:Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration:BoxDecoration(
                      image:DecorationImage(image:FileImage(file),
                      fit: BoxFit.cover
                      )
                      ),

                  ),
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(top:12.0),
            ),
            ListTile(
              leading:Icon(Icons.library_books,
              color:Colors.white),
              title:Container(
              width:250.0,
              child:TextField(
                style:TextStyle(color: Colors.white,
                fontFamily: 'CrimsonText-SemiBold',
                fontSize: 20.0,),
                controller:_shortInfoTextEditingController,
                decoration: InputDecoration(
                 hintText:"Short Info",
                 hintStyle: TextStyle(color:Colors.white,
                 fontFamily: 'CrimsonText-SemiBold'),
                 border:InputBorder.none
                ),
              )
            )
            ),
            Divider(color:Colors.white70),

            ListTile(
              leading:Icon(Icons.title_outlined,
              color:Colors.white),
              title:Container(
              width:250.0,
              child:TextField(
                style:TextStyle(color: Colors.white,
                fontFamily: 'CrimsonText-SemiBold',
                fontSize: 20.0),
                controller:_titleTextEditingController,
                decoration: InputDecoration(
                 hintText:"Title for product",
                 hintStyle: TextStyle(color:Colors.white),
                 border:InputBorder.none
                ),
              )
            )
            ),
            Divider(color:Colors.white70),

            ListTile(
              leading:Icon(Icons.description_outlined,
              color:Colors.white),
              title:Container(
              width:250.0,
              child:TextField(
                style:TextStyle(color: Colors.white,
                fontFamily: 'CrimsonText-SemiBold',
                fontSize: 20.0),
                
                controller:_descriptionTextEditingController,
                decoration: InputDecoration(
                 hintText:"Description ",
                 hintStyle: TextStyle(color:Colors.white,),
                 border:InputBorder.none
                ),
              )
            )
            ),
            Divider(color:Colors.white70),

            ListTile(
              leading:Icon(Icons.money_outlined,
              color:Colors.white),
              title:Container(
              width:250.0,
              child:TextField(
                keyboardType: TextInputType.number,
                style:TextStyle(color: Colors.white,
                fontFamily: 'CrimsonText-SemiBold',
                fontSize: 20.0,
                ),
                controller:_priceTextEditingController,
                decoration: InputDecoration(
                 hintText:"Price",
                 hintStyle: TextStyle(color:Colors.white),
                 border:InputBorder.none
                ),
              )
            )
            ),
            Divider(color:Colors.white70),
          ],
          
         ),
         backgroundColor:Colors.black ,
    );
  }

  clearFormInfo()
  {
    setState((){
      file= null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }


  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

 Future<String> uploadItemImage(mFileImage) async
 {
   final StorageReference storageReference = FirebaseStorage.instance.ref().child("Items");
   StorageUploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
   return downloadUrl;
 }

 saveItemInfo(String downloadUrl)
 {
   final itemsRef = Firestore.instance.collection('items');
   itemsRef.document(productId).setData({
     "shortInfo": _shortInfoTextEditingController.text.trim(),
     "longDescription": _descriptionTextEditingController.text.trim(),
     "price": int.parse(_priceTextEditingController.text),
     "publishedDate": DateTime.now(),
     "status" : "available",
     "thumbnailUrl": downloadUrl,
     "title" : _titleTextEditingController.text.trim(),
   });

   setState(() {
     file = null ;
     uploading = false;
     productId = DateTime.now().millisecondsSinceEpoch.toString();
     _descriptionTextEditingController.clear();
     _shortInfoTextEditingController.clear();
     _priceTextEditingController.clear();
     _titleTextEditingController.clear();
   });
 }
}
