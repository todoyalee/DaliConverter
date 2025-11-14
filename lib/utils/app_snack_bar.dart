import 'package:flutter/material.dart';

import 'package:get/get.dart';


class AppCustomSnackBar{

final BuildContext context;
final String text;

final bool isForever;

final   SnackBarAction? action ;

final Color? backgroundColor;

final bool isFloating;


AppCustomSnackBar({
   required this.context,
   required this.text,
       this.isForever=false,
    this.action,

    this.backgroundColor,
    this.isFloating=false
    
});



void show(){
   final SnackBar snackBar=SnackBar(

behavior: isFloating ? SnackBarBehavior.floating:null,

shape:  isFloating
 ? RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)):null
 ,

 duration:  isForever ? const Duration(days: 365):const Duration(seconds: 5),

 content: Text(text,style: TextStyle(fontWeight: FontWeight.bold,
 color: !Get.isDarkMode ? Colors.white:Colors.black
 ),),

 backgroundColor: backgroundColor ??(!Get.isDarkMode ? Colors.black:Colors.white),
 action: action,
   

 


   );

   if(text.isNotEmpty && text!=''){
    ScaffoldMessenger.of(


      context,
    ).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }
}


}