import 'package:flutter/material.dart';
import 'package:sellers_app/global/global_instances.dart';

import '../widgets/custom_text_field.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
{
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            alignment: Alignment.bottomCenter ,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                "images/seller.png",
                height: 270,
                //video5
              ),
            ),
          ),

          Form(
            key: formKey,
            child: Column(
              children: [

              CustomTextField(
                textEditingController: emailTextEditingController,
                iconData: Icons.email,
                hintString: "Email",
                isObscure: false,
                enabled: true,
              ),

                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.lock,
                  hintString: "Password",
                  isObscure: true,
                  enabled: true,
                ),


                ElevatedButton(
                    onPressed: ()
                    {
                      authViewModel.validateSignInForm(
                        emailTextEditingController.text.trim(),
                        passwordTextEditingController.text.trim(),
                        context,
                      );
                    } ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10)
                  ),
                  child: const Text(
                    "Entrar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),
          ),


        ],
      ),
    );
  }
}
