import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
   const PhotoCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          decoration:const  BoxDecoration(
                   color: Colors.white,
                   boxShadow:[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(10 ,10))
                   ],),
                   child: SizedBox(
          width: 400,
          height: 500,
          child:child
        ),
        ),
        
      ],
    );
  }
}