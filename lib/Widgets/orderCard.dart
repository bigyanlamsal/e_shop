import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Orders/OrderDetailsPage.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';

int counter = 0;
class OrderCard extends StatelessWidget {
  

  final int itemCount;
  final List<DocumentSnapshot>data;
  final String orderID;

  OrderCard({Key key, this.itemCount,this.data,this.orderID}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
      Route route;
      if(counter==0)
      {
        counter = counter + 1;
        route = MaterialPageRoute(builder:(c)=> OrderDetails(orderID: orderID));
      }
      Navigator.push(context, route);
      },
      child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("images/background1.jpg"),
          fit: BoxFit.fill,
          ) 
          ),
          padding:EdgeInsets.all(10.0),
          margin:EdgeInsets.all(10.0),
          height: itemCount * 190.0,
          child:ListView.builder(
            itemCount:itemCount,
            physics:NeverScrollableScrollPhysics(),
            itemBuilder:(c,index)
            {
              ItemModel model = ItemModel.fromJson(data[index].data);
              return sourceOrderInfo(model, context);
            }
          ),
      ),
    );
  }
}

 Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background:Colors.red})
{
  width =  MediaQuery.of(context).size.width;

  return  Container(
    color:Colors.brown,
     height:170.0,
      width: width,
      child: Row(
        children: [
          Image.network(model.thumbnailUrl,width:115.0,
          ),
          SizedBox(width:10.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:20.0),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text
                      (
                        model.title,
                        style:TextStyle
                        (
                        color:Colors.white,
                        fontSize: 22.0,
                        fontFamily: "CrimsonText-SemiBold"
                        ),
                        ),
                        ),
                    ],
                    ),
                    ),
                  SizedBox(height:5.0,),
                  Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text
                      (
                        model.shortInfo,
                        style:TextStyle(
                        color:Colors.white,
                        fontSize: 14.0,
                        fontFamily: "CrimsonText-SemiBold"
                        ),
                        ),
                        ),
                    ],
                    ),
                    ),
                    SizedBox(height:20.0),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding: EdgeInsets.only(top:5.0),
                              child: Row(
                                children:[
                                  Text(r"Total Price : ",
                                  style:TextStyle(
                                    fontSize: 14.0,
                                    color:Colors.white,
                                  )
                                  ),
                                  Text(
                                    "Nrs",
                                    style:TextStyle(color:Colors.white,fontSize: 16.0,fontWeight: FontWeight.bold)
                                  ),
                                  Text(
                                    (model.price).toString(),
                                  style:TextStyle(
                                    fontSize: 15.0,
                                    color:Colors.white,
                                  )
                                  )
                                ]
                              ),
                            ),
                          ],
                        )
                      ],
                      ),
                      Flexible(child: Container(),
                      ),  
                      Divider(color: Colors.white,)     
              ],
          )
          ), 
        ],
      ),
  );
}
