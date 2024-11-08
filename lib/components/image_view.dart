import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key , required this.data});

  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Card(
            child: Stack(
              children: [
                Image.network(data.images[0].link,fit: BoxFit.cover,),
                Positioned(
                  bottom: 0,
                  child: Text(data.title,style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),))
              ],
            ),
          ),
        ),
      )
    );
  }
}