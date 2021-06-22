import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      
      child: ListView(
          children: [
           Container(
          // Background Image 
          decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("images/background1.jpg"),
          fit: BoxFit.fill,
          ) 
          ),
         
         // User Avatar Design 

        child: Column(
          children:[
            Material(
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
            elevation: 8.0,
            child:Container(
              height: 160.0,
              width: 160.0,
              child:CircleAvatar(
                backgroundImage:NetworkImage(
                  EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                )
              )
            )
            ),
            SizedBox(height:10.0),
            Text(
              EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
              style:TextStyle(color: Colors.white,fontSize: 35.0,fontFamily: "CrimsonText-Regular"),
            )
          ]
        )
           ),

           SizedBox(height:1.0),
           Container(
             padding:EdgeInsets.only(top:1.0),
              decoration: new BoxDecoration(
          image: new DecorationImage(
          image: new AssetImage("images/background1.jpg"),
          fit: BoxFit.fill,
          ) 
          ),


        //--------Drawer Starts Here-----------
          
          child:LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child:Column(
            children: [
              ListTile(
                leading:Icon(Icons.home,color:Colors.white),
                title: Text("Home",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => StoreHome());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

             ListTile(
                leading:Icon(Icons.shopping_cart,color:Colors.white),
                title: Text("My Orders",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => MyOrders());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.add_shopping_cart_outlined,color:Colors.white),
                title: Text("My Cart",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => CartPage());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.search_outlined,color:Colors.white),
                title: Text("Search",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => SearchProduct());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.location_city_outlined,color:Colors.white),
                title: Text("Add Adress",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => AddAddress());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.book_outlined,color:Colors.white),
                title: Text("Owner Details",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => StoreHome());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.logout,color:Colors.white),
                title: Text("Log Out",style:TextStyle(color:Colors.white),),
                onTap: (){
                  EcommerceApp.auth.signOut().then((c){
                 Route route = MaterialPageRoute(builder: (c)
                  => AuthenticScreen());
                  Navigator.pushReplacement(context,route);
                  });
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              ),

               ListTile(
                leading:Icon(Icons.computer_outlined,color:Colors.white),
                title: Text("About Developer",style:TextStyle(color:Colors.white),),
                onTap: (){
                  Route route = MaterialPageRoute(builder: (c)
                  => StoreHome());
                  Navigator.pushReplacement(context,route);
                },
              ),

              Divider(height:10.0,
              color:Colors.white38,thickness: 6.0,
              )

              // Drawer ends here
            

            ]
                )
                );
            }
          )
           )

          ],
      ),
    );
  }
}
