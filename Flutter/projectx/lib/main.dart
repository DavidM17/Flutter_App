import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: new MyHomePage(title: 'Instagram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,this.title}): super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<List<User>> _getUsers() async {
     
    final data = await http.get("http://www.json-generator.com/api/json/get/bVogsyzrTm?indent=2");

    final jsonData = json.decode(data.body); 

    List<User> users = [];
 
    for(var u in jsonData){

      User user = User(u["index"],u["about"],u["name"],u["email"],u["picture"],u["post"],u["address"]);

      users.add(user);
    } 
    return users;
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title)
      ),
      bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home, color: Colors.black54),
           title: new Text('Home', style: TextStyle(color: Colors.black54)),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.mail, color: Colors.black54),
           title: new Text('Messages',style: TextStyle(color: Colors.black54)),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person, color: Colors.black54),
           title: Text('Profile',style: TextStyle(color: Colors.black54))
         )
       ],
     ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            
            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            }else{ 
            
            return ListView.builder(
              
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){

                return Column(children: <Widget>[

                  GestureDetector(
                    onTap: (){
                    Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[
                    CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data[index].picture
                    ),
                  ),
			
		  Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Text(snapshot.data[index].name,style: TextStyle(fontFamily: 'Roboto')),
                  ),
		  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Text(snapshot.data[index].address,style: TextStyle(fontSize:10.0)),
                  ),
		  ], )
                    ],
                    ),),
                  
                  ),
        
                  GestureDetector(
                    onTap: (){
                    Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => DetailPost(snapshot.data[index]))
                    );
                  },
                  child: Image.network(snapshot.data[index].post),
                  ),
                  

                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[
                    
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/heart.png'),height: 30.0,width: 25.0),
                    ),
                     
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/comment.png'),height: 30.0,width: 25.0),
                    ), 
                  
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/share.png'),height: 30.0,width: 25.0),
                    ), 

                    ],
                    ),),
                  
  
                ]);
               
 
              },
            );
             } // Final part 
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {

  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    
    body:Container(
             padding: EdgeInsets.fromLTRB(130.0, 0.0, 0.0, 0.0),
             child: 

	Column( children: <Widget>[

	
	CircleAvatar(
	    backgroundImage: NetworkImage(
	      user.picture
	    ),
	    radius: 60.0
	  ),
      Container(
        child: Text('Location:'+user.address),
      ),
      Container(
        child: Text('Email:'+user.email),
      ),
	
    ],),
	)
    );
  }
}


class DetailPost extends StatelessWidget {

  final User user;
 
  DetailPost(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    bottomNavigationBar: BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home, color: Colors.black54),
           title: new Text('Home', style: TextStyle(color: Colors.black54)),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.mail, color: Colors.black54),
           title: new Text('Messages',style: TextStyle(color: Colors.black54)),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person, color: Colors.black54),
           title: Text('Profile',style: TextStyle(color: Colors.black54))
         )
       ],
     ),
    body: Column( children: <Widget>[

      Image.network(user.post),

       Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(children: <Widget>[
                    
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/heart.png'),height: 30.0,width: 25.0),
                    ),
                     
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/comment.png'),height: 30.0,width: 25.0),
                    ), 
                  
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      child: SizedBox(child: Image.asset('images/share.png'),height: 30.0,width: 25.0),
                    ), 

                    ],
                    ),),
      
      Container(
        child: Text(user.about),
      ),

    ],),
    );
  }
}


class User {
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;
  final String post;
  final String address;
  

  User(this.index,this.about,this.name,this.email,this.picture,this.post,this.address);
}



