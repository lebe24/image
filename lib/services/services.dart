import 'package:dio/dio.dart';
import 'package:image/model/model.dart';

var dio = Dio();

const String baseUrl = "https://api.imgur.com/3/gallery/";
const String clientId = "api-key";

var headers = {
  'Authorization': 'Client-ID $clientId'
};

// Function to fetch popular images from Imgur API
Future<ImageData> getPopular(String section, String sort, String window) async {
  try {
    var response = await dio.get(
      '$baseUrl$section/$sort/$window',
      options: Options(
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      // debugPrint(response.data);
      return ImageData.fromJson(response.data);
    } else {
      throw Exception("Failed to load images: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}

// Function to search images from Imgur API

Future<ImageData> search(
  String query,int page
) async{
  try{
    var response = await dio.get(
      '$baseUrl/search/time/all/$page?q=$query',
        options: Options(
          headers: headers,
        ),
      );
    if (response.statusCode == 200) {
          return ImageData.fromJson(response.data);
      } else {
        throw Exception("Failed to load images: ${response.statusCode}");
      }
  }catch(e){
    throw Exception("Error: $e");
  }
}

// https://api.imgur.com/3/gallery/search/{{sort}}/{{window}}/{{page}}?q=cats