import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/ViewModel/common_view_model.dart';
import 'package:sellers_app/commonMethods/common_methods.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;

import 'package:shared_preferences/shared_preferences.dart';
import '../../global/global_instances.dart';
import '../../global/global_vars.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
{

  XFile? imageFile;
  ImagePicker pickerImage = ImagePicker();
  String imageUrl  = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();



  CommonMethods cMethods = CommonMethods();

  User? currentFirebaseUser;

  pickImageFromGallery() async
  {
    imageFile = await pickerImage.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile;
    });
  }


//V10
  validateForm() async
  {
    //Solicitamos que cargue una imagen
    if(imageFile == null)
      {
        //Mensajes de Alerta se llama del directorio commonMethods V10

          cMethods.displaySnackBar("Seleecione una Imagen", context);
      }
    else
      {
        if(passwordTextEditingController.text.trim() == confirmPasswordTextEditingController.text.trim())
          {
            if(nameTextEditingController.text.isNotEmpty
                && emailTextEditingController.text.isNotEmpty
                && passwordTextEditingController.text.isNotEmpty
                && confirmPasswordTextEditingController.text.isNotEmpty
                && phoneTextEditingController.text.isNotEmpty
                && locationTextEditingController.text.isNotEmpty)
              {
                  //1.register new user - upload image - authentication - save to firestore database
                  await uploadImageToStorage();



              }
            else
              {
                cMethods.displaySnackBar("Todos los Campos deben ser Completados", context);
              }
          }
        else
          {

            //Mensajes de Alerta se llama del directorio commonMethods V10

            cMethods.displaySnackBar("Las Contraseñas deben ser iguales", context);
          }
      }
  }

    uploadImageToStorage() async
    {
      //V11
      //1. upload image to firebase storage
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      firebaseStorage.Reference referenceStorage = firebaseStorage.FirebaseStorage.instance.ref()
          .child("SellersImages").child(fileName + ".jpg");

      firebaseStorage.UploadTask taskUpload = referenceStorage.putFile(File(imageFile!.path));

      firebaseStorage.TaskSnapshot snapshotTask = await taskUpload.whenComplete(() {});

      await snapshotTask.ref.getDownloadURL().then((value)
      {
        imageUrl = value;
      });
      authenticateAccount();
    }

    authenticateAccount() async

    {
      //2. Authenticate new seller using firebase authenticationV12
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
      ).then((valueAuth)
      {
        currentFirebaseUser = valueAuth.user;
      }).catchError((errorMessage)
      {
        cMethods.displaySnackBar(errorMessage.toString(), context);
        return;
      });
      if(currentFirebaseUser != null)
      {
        //3.save seller data to firebase databaseV12
        saveDataToFirestoreDatabase();//V13
      }
    }

    saveDataToFirestoreDatabase() async
    {
      FirebaseFirestore.instance.collection("sellers").doc(currentFirebaseUser!.uid).set(
          {
            "sellerUID": currentFirebaseUser!.uid,
            "sellerName": nameTextEditingController.text.trim(),
            "sellerEmail":currentFirebaseUser!.email,
            "sellerPhone":phoneTextEditingController.text.trim(),
            "sellerImageUrl": imageUrl,
            "sellerAddress": fullAddress,
            "lat":position!.latitude,
            "lng":position!.longitude,
            "status": "approved",
            "earnings": 0.0,
          });
        //save data locally to phone storage
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("uid", currentFirebaseUser!.uid);
      await sharedPreferences.setString("email", currentFirebaseUser!.email.toString());
      await sharedPreferences.setString("name", nameTextEditingController.text.trim());
      await sharedPreferences.setString("imageUrl", imageUrl);
      
      cMethods.displaySnackBar("Cuenta Creada Correctamente", context);

      Navigator.push(context,MaterialPageRoute(builder: (c)=> HomeScreen()));
    }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [

           const SizedBox(height: 11,),

            InkWell(
              onTap: ()
              {
                pickImageFromGallery();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageFile == null? null : FileImage(File(imageFile!.path)),
                child: imageFile == null
                    ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey,
                )
                    : null,
              ),
            ),


            const SizedBox(height: 11,),


            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintString: "Nombre",
                    isObscure: false,
                    enabled: true,
                  ),


                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintString: "Email",
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: phoneTextEditingController,
                    iconData: Icons.phone,
                    hintString: "Telefono",
                    isObscure: false,
                    enabled: true,
                  ),

                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    hintString: "Clave",
                    isObscure: true,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    iconData: Icons.lock,
                    hintString: "Confirme su clave",
                    isObscure: true,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: locationTextEditingController,
                    iconData: Icons.my_location,
                    hintString: "Direccion",
                    isObscure: false,
                    enabled: true,
                  ),

                  Container(
                    width: 398,
                    height: 39,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () async
                      {
                       String address =  await commonViewModel.getCurrentLocation();
                       setState(() {
                         locationTextEditingController.text = address;
                       });
                      } ,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      label: const Text(
                        "Localizacion",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                         Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 31,),


                  ElevatedButton(
                    onPressed: () async
                    {
                    //  validateForm();
                      await authViewModel.validateSignUpForm(
                          imageFile,
                          passwordTextEditingController.text.trim(),
                          confirmPasswordTextEditingController.text.trim(),
                          nameTextEditingController.text.trim(),
                          emailTextEditingController.text.trim(),
                          phoneTextEditingController.text.trim(),
                          fullAddress,
                          context,
                      );
                    } ,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
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
                  const SizedBox(height: 31,),
                ],
              ),
            ),

          ],
      ),
    );
  }
}
//7 listo
//11 listo