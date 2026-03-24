import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:user_management/user_provider.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key,});
  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? image;
  bool showSpinner = false;
  final _picked = ImagePicker();

  @override
  void initState() {
    super.initState();

  }

  Future getImage() async {
    final pickedFile = await _picked.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      setState(() {
        return;
      });
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });

    var uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/${dotenv.env['CLOUD_NAME']}/image/upload",
    );

    var request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = dotenv.env['UPLOAD_PRESET']!;

    request.files.add(await http.MultipartFile.fromPath('file', image!.path));

    var imageResponse = await request.send();
    final bytes = await imageResponse.stream.toBytes();
    final jsonResponse = jsonDecode(String.fromCharCodes(bytes));

    String imageUrl = jsonResponse['secure_url'];
    context.read<UserProvider>().setImageUrl(imageUrl);
    setState(() {
      showSpinner = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Upload User's Image",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: image == null
                    ? OutlinedButton(
                        onPressed: () {
                          getImage();
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          "Pick Image",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Image.file(
                          File(image!.path).absolute,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: () {
                      if (image != null) {
                        uploadImage();
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("You did'nt selected the image"),
                          ),
                        );
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Text(
                      "Upload",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
