import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../global/global_var.dart';
import '../model/menus.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

import '../widgets/error_dialog.dart';

class ItemsUploadScreen extends StatefulWidget
{
  final Menus? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen>
{

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController =TextEditingController();
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  TextEditingController priceController =TextEditingController();

  bool upload = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Item",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenuUploadForm();
          },
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.white, size: 200.0,),
              ElevatedButton(
                child: const Text(
                  "Add New Items",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )
                    )
                ),
                onPressed: ()
                {
                  takeImage(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return SimpleDialog(
          title: const Text("Menu Image", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                "Capture with camera",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                "Select From Gallery",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemsUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Uploading New Item",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenuUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
            onPressed: upload ? null : ()=> validateUploadForm(),

          ),
        ],
      ),
      body: ListView(
        children: [
          upload == true ? const LinearProgressIndicator() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.title, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.description, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.price_change, color: Colors.cyan,),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm()
  {
    setState(()
    {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;


    });
  }

  validateUploadForm() async
  {

    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && priceController.text.isNotEmpty && descriptionController.text.isNotEmpty)
      {
        setState(() {
          upload = true;
        });
        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to fireStore
        saveInfo(downloadUrl, shortInfoController.text, titleController.text);

      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {

              return ErrorDialog(
                message: "Please write title and info",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {

            return ErrorDialog(
              message: "Please pick an image",
            );
          }
      );

    }

    // upload image
    // String downloadUrl = await uploadImage(File(imageXFile!.path));
    //save info to database

  }

  uploadImage(mImageFile) async
  {
    storageRef.Reference reference = storageRef.FirebaseStorage.instance.ref().child("items");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveInfo(String downloadUrl,String shortInfo,String titleMenu)
  {
    final ref = FirebaseFirestore.instance
        .collection("seller")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(widget.model!.menuID)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemID" : uniqueIdName,
      "menuID" : widget.model!.menuID,
      "sellerUID" : sharedPreferences!.getString("uid"),
      "sellerName" : sharedPreferences!.getString("name"),
      "shortInfo" : shortInfoController.text.toString(),
      "longDescription" : descriptionController.text.toString(),
      "price" : int.parse(priceController.text),
      "title" : titleController.text.toString(),
      "publishedDate" : DateTime.now().toString(),
      "status" : "available",
      "thumbnailUrl" : downloadUrl,
    }).then((value)
    {
      final itemRef = FirebaseFirestore.instance
          .collection("items");

      itemRef.doc(uniqueIdName).set({
        "itemID" : uniqueIdName,
        "menuID" : widget.model!.menuID,
        "sellerUID" : sharedPreferences!.getString("uid"),
        "sellerName" : sharedPreferences!.getString("name"),
        "shortInfo" : shortInfoController.text.toString(),
        "longDescription" : descriptionController.text.toString(),
        "price" : int.parse(priceController.text),
        "title" : titleController.text.toString(),
        "publishedDate" : DateTime.now().toString(),
        "status" : "available",
        "thumbnailUrl" : downloadUrl,
      });
    }).then((value)
    {

      clearMenuUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        upload = false;
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
