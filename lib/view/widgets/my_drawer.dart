import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:sellers_app/global/global_vars.dart';
import 'package:sellers_app/view/mainScreens/home_screen.dart';
import 'package:sellers_app/view/splashScreen/splash_screen.dart';

import '../pedidos/agregar_pedidos.dart';
import '../pedidos/ver_pedidos.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children:
        [
          //header
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [

                //imageV16
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(81)),
                  elevation: 8,
                  child: SizedBox(
                    height: 158,
                    width: 158,
                    child: CircleAvatar(
                      backgroundImage:NetworkImage(
                        sharedPreferences!.getString("imageUrl").toString(),
                      ) ,
                    ),
                  ),
                ),

                const SizedBox(height:12,),

                Text(
                  sharedPreferences!.getString("name").toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 15,),


          //bodyV17
          Container(
            child: Column(
              children: [

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white,),
                  title: const Text(
                    "Inicio",
                     style: TextStyle(color: Colors.white),
                  ),
                  onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                    }
                ),

                //1
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                    leading: const Icon(Icons.home, color: Colors.white,),
                    title: const Text(
                      "Agregar Pedido",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => AgregarPedidoScreen()));
                    }
                ),

                //2
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                    leading: const Icon(Icons.monetization_on, color: Colors.white,),
                    title: const Text(
                      "Mis Ganancias",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> VerPedidosScreen()));
                    }
                ),

                //3



                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.white,),
                    title: const Text(
                      "Cerrar Sesion",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: ()
                    {
                      FirebaseAuth.instance.signOut();

                      Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
                    }
                ),

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
