import 'package:flutter/material.dart';
import 'package:sellers_app/view/authScreens/signin_screen.dart';
import 'package:sellers_app/view/authScreens/signup_screen.dart';



class AuthScreen extends StatefulWidget {
  //Diferente al Tutorial
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Nombre de la App",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color:  Colors.white,),
                text: "Entrar",
              ),
              Tab(
                icon: Icon(Icons.person, color:  Colors.white,),
                text: "Registro",
              ),
            ],
            indicatorColor: Colors.white38 ,
            indicatorWeight: 5,
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: const TabBarView(
            children: [
              SigninScreen(),
              SignupScreen(),
            ],
          ),
        ),
      ),
    ) ;
  }
}
