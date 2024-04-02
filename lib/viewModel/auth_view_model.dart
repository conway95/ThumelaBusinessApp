import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../global/global_instances.dart';
import '../global/global_var.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/loading_dialog.dart';

class AuthViewModel
{
  validateSignUpForm(XFile? imageXFile, String password,String confirmPassword, String name, String email, String phone, String locationAddress, BuildContext context) async
  {
    if(imageXFile == null)
    {
      commonViewModel.showsSnackBar("Please select image file.", context);
      return;
    }
    else
    {
      if(password == confirmPassword)
      {
        if(name.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && locationAddress.isNotEmpty)
        {
          showDialog(
              context: context,
              builder: (c)
              {
                return LoadingDialog(
                  message: "Registering Account",
                );
              }
          );

          User? currentFirebaseUser = await createUserInFirebaseAuth(email, password, context);

          String downloadUrl = await uploadImageToStorage(imageXFile);

          await saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress, phone);

          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));


        }
        else
        {
          commonViewModel.showsSnackBar("Please fill all fields.", context);
          return;
        }
      }
      else
      {
        commonViewModel.showsSnackBar("Passwords do not match.", context);
        return;
      }
    }
  }

  createUserInFirebaseAuth(String email, String password, BuildContext context) async
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
      commonViewModel.showsSnackBar(errorMsg, context);
    });

    if(currentFirebaseUser == null)
    {
      FirebaseAuth.instance.signOut();
      return;
    }

    return currentFirebaseUser;
  }

  uploadImageToStorage(XFile? imageXFile) async
  {
    String downloadUrl = "";

    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance.ref().child("sellerImages").child(fileName);
    fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    await taskSnapshot.ref.getDownloadURL().then((urlImage)
    {
      downloadUrl = urlImage;
    });

    return downloadUrl;
  }

  saveUserDataToFirestore(currentFirebaseUser, downloadUrl, name, email, password, locationAddress, phone)
  async {
    FirebaseFirestore.instance.collection("seller").doc(currentFirebaseUser.uid)
        .set(
        {
          "uid": currentFirebaseUser.uid,
          "email": email,
          "name": name,
          "image": downloadUrl,
          "phone": phone,
          "address": locationAddress,
          "status": "approved",
          "earnings": 0.0,
          "latitude": position!.latitude,
          "longitude": position! .longitude
        });

    await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
    await sharedPreferences!.setString("email", email);
    await sharedPreferences!.setString("name", name);
    await sharedPreferences!.setString("imageUrl", downloadUrl);
  }

  validateSignInForm(String email, String password, BuildContext context)
  async {
    if(email.isNotEmpty && password.isNotEmpty)
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return LoadingDialog(
              message: "Checking credentials",
            );
          }
      );

      User? currentFirebaseUser = await loginUser(email, password, context);

      await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, context);

      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
    }
    else
    {
      commonViewModel.showsSnackBar("Email and Password are required", context);
      return;
    }
  }

  loginUser(email, password, context) async
  {
    User? currentFirebaseUser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((valueAuth) {
      currentFirebaseUser = valueAuth.user;
    }).catchError((errorMsg) {
      commonViewModel.showsSnackBar(errorMsg, context);
    });

    if(currentFirebaseUser == null)
    {
      FirebaseAuth.instance.signOut();
      return;
    }

    return currentFirebaseUser;

  }

  readDataFromFirestoreAndSetDataLocally(User? currentFirebaseUser,BuildContext context) async
  {
    await FirebaseFirestore.instance
        .collection("seller")
        .doc(currentFirebaseUser!.uid)
        .get()
        .then((dataSnapShot) async
    {
      if(dataSnapShot.exists)
      {
        if(dataSnapShot.data()!["status"] == "approved")
        {
          await sharedPreferences!.setString("uid", currentFirebaseUser.uid);
          await sharedPreferences!.setString("email", dataSnapShot.data()!["email"]);
          await sharedPreferences!.setString("name", dataSnapShot.data()!["name"]);
          await sharedPreferences!.setString("imageUrl", dataSnapShot.data()!["image"]);
        }
        else
        {
          commonViewModel.showsSnackBar("you have been blocked by admin", context);
          FirebaseAuth.instance.signOut();
          return;
        }
      }
      else
      {
        commonViewModel.showsSnackBar("This sellers do not exist", context);
        FirebaseAuth.instance.signOut();
        return;
      }
    });
  }

}