import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Counters/cartitemcounter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:e_shop/main.dart';


class PaymentPage extends StatefulWidget 
{
  final String addressId;
  final double totalAmount;
  PaymentPage({Key key,this.addressId,this.totalAmount}): super(key:key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}




class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
         decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("images/background1.jpg"),
          fit: BoxFit.fill,
          ) 
          ),
          child:Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(8.0),
                child:Image.asset("images/cash.png",
                width: 100.0,
                height: 90.0,),
                ),
                SizedBox(height:10.0),
                FlatButton(
                  color:Colors.cyan,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.deepPurpleAccent,
                  onPressed:()=>addOrderDetails(),
                  child: Text("Place Order",style:TextStyle(fontSize: 20.0)),
                ),
               SizedBox(height:20.0,width: 50.0,),
               Text("Cash on delivery!!!",style: TextStyle(color: Colors.white),),
               SizedBox(height:20.0,width: 50.0,),
               InkWell(
                 child: Container(
                   child:Image.asset("images/man.png",
                   width:80.0,
                   height: 80.0,
                   ),
                   
                 ),
                 
               ),
                SizedBox(height:20.0,width: 50.0,),
               Text("Keep your city clean and green ",style: TextStyle(color: Colors.lightGreenAccent),),
              ],
            ),
            
          )
      ),
    );
  }

addOrderDetails()
{
  writeOrderDetailsForUser({
   EcommerceApp.addressID:widget.addressId,
   EcommerceApp.totalAmount:widget.totalAmount,
   "orderBy":EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
   EcommerceApp.productID:EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
   EcommerceApp.paymentDetails:"Cash on Delivery",
   EcommerceApp.orderTime:DateTime.now().millisecondsSinceEpoch.toString(),
   EcommerceApp.isSuccess:true,
  });

  writeOrderDetailsForAdmin({
   EcommerceApp.addressID:widget.addressId,
   EcommerceApp.totalAmount:widget.totalAmount,
   "orderBy":EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
   EcommerceApp.productID:EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList),
   EcommerceApp.paymentDetails:"Cash on Delivery",
   EcommerceApp.orderTime:DateTime.now().millisecondsSinceEpoch.toString(),
   EcommerceApp.isSuccess:true,
  }).whenComplete(()=>{
    emptyCartNow()
  });
}

  emptyCartNow()
  {
    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,["garbageValue"]);
    List tempList = EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

     Firestore.instance.collection("users").document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
     .updateData
     (
       {
      EcommerceApp.userCartList:tempList,
      }
    ).then((value)
    {
      EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList,tempList);
      Provider.of<CartItemCounter>(context,listen:false).displayResult();
    });
    Fluttertoast.showToast(msg: "Your order has been placed successfully");
    Route route = MaterialPageRoute(builder: (c)=>SplashScreen());
    Navigator.pushReplacement(context,route);
  }

  Future writeOrderDetailsForUser(Map<String,dynamic>data) async
  {
    await EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
    .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
    .collection(EcommerceApp.collectionOrders)
    .document(EcommerceApp.sharedPreferences
    .getString(EcommerceApp.userUID)+ data['orderTime']).setData(data);
    
  }

  Future writeOrderDetailsForAdmin(Map<String,dynamic>data) async
  {
    await EcommerceApp.firestore
    .collection(EcommerceApp.collectionOrders)
    .document(EcommerceApp.sharedPreferences
    .getString(EcommerceApp.userUID)+ data['orderTime']).setData(data);

  }
}
