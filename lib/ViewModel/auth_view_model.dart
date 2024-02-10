import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global_instances.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:sellers_app/global/global_vars.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel
{
  //Video#12
  validateSignUpForm(XFile? imageXFile, String password, String confirmPassword, String name, String email, String phone, String locationAddress, BuildContext context) async
  {
      if(imageXFile == null)
        {
          commonViewModel.showSnackBar("Seleccione una Imagen 12", context);
          return;
        }
      else
        {
          if(password == confirmPassword)
            {
              //Borra locationAddress V12
              if(name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && phone.isNotEmpty && locationAddress.isNotEmpty)
                {
                  User? currentFirebaseUser =  await createUserInFirebaseAuth(email, password, context);

                  String downloadUrl = await uploadImageToStorage(imageXFile);

                  await saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress, phone);
                }
              else
                {
                  commonViewModel.showSnackBar("Complete todos los campos 12", context);
                  return;
                }
            }
          else
            {
              commonViewModel.showSnackBar("Contraseñas deben ser Iguales 12", context);
              return;
            }
        }
  }

  //V13
  createUserInFirebaseAuth(String email, String password, BuildContext context)async
  {
    User? currentFirebaseUser;

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((valueAuth)
    {
       currentFirebaseUser = valueAuth.user;
    }).catchError((errorMsg)
    {
       commonViewModel.showSnackBar(errorMsg, context);
    });

    if(currentFirebaseUser == null)
      {
        return;
      }
    return currentFirebaseUser;
  }

  //V13
  uploadImageToStorage(XFile? imageXFile) async
  {
    String downloadUrl = "";

     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
     fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("sellerImages").child(fileName);
     fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXFile!.path));
     fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
     await taskSnapshot.ref.getDownloadURL().then((urlImage)
     {
        downloadUrl = urlImage;
     });
     return downloadUrl;
  }

  //V13
  saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress, phone) async
  {
    FirebaseFirestore.instance.collection("sellers").doc(currentFirebaseUser.uid)
        .set(
        {
          "uid": currentFirebaseUser.uid,
          "email":email,
          "name":name,
          "image": downloadUrl,
          "phone": phone,
          "address": locationAddress,
          "status": "approved",
          "earnings": 0.0,
          "latitude": position!.latitude,
          "longitude": position!.longitude,
        });

        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
        await sharedPreferences!.setString("email", email);
        await sharedPreferences!.setString("name", name);
        await sharedPreferences!.setString("imageUrl", downloadUrl);

  }
}