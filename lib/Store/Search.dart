
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/customAppBar.dart';

class SearchService {
}



class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}



class _SearchProductState extends State<SearchProduct> {

  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child:searchWidget(),
            preferredSize:Size(56.0,56.0)
            ),
            ),
          body:FutureBuilder<QuerySnapshot>(
            future:docList,
            builder:(context,snap)
            {
              return snap.hasData
              ? ListView.builder(
                itemCount: snap.data.documents.length,
                itemBuilder: (context,index)
                {
                  ItemModel model =ItemModel.fromJson(snap.data.documents[index].data);
                  return sourceInfo(model,context);
                },
              )
              : notAvailable();
            }
          )  
        )
    );
  }

  Widget searchWidget()
  {
   return Container(
     alignment:Alignment.center,
     width: MediaQuery.of(context).size.width,
     height: 80.0,
     decoration: new BoxDecoration(
      image: new DecorationImage(
      image: new AssetImage("images/background1.jpg"),
      fit: BoxFit.fill,
      ) 
    ),
    child:Container(
       width: MediaQuery.of(context).size.width-40.0,
       height: 50.0,
       decoration:BoxDecoration(
         color:Colors.white,
         borderRadius: BorderRadius.circular(6.0),
       ),
       child:Row(
         children: [
           Padding(
             padding:EdgeInsets.only(left:8.0),
             child:Icon(Icons.search,color:Colors.blueGrey)
           ),
           Flexible(
             child: Padding(
               padding:EdgeInsets.only(left:8.0),
               child: TextField(
                 onChanged:(value){
                   startSearching(value);
                 },
                 decoration:InputDecoration.collapsed(hintText:"Search here.."),

               ),
             ),
           )
         ],
       )
    )
   );
  }

  Widget notAvailable(){

      return Card(
       color : Colors.redAccent,
       child:Container(
       width: MediaQuery.of(context).size.width,
         height: 100.0,
         child:Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.insert_emoticon,color:Colors.white,),
             Text("Sorry ! Not Available",
             style:TextStyle(
             fontSize: 20.0,
             color:Colors.white,),)
           ],
         ) ,
       )
     
    );

  }

  Future startSearching(String query) async
  {
    docList= Firestore.instance.collection("items")
    .where("shortInfo",isGreaterThanOrEqualTo: query)
    .getDocuments();
  }
}
