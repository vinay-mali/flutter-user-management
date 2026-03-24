import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_management/ui_widgets.dart';
import 'package:user_management/upload_image_screen.dart';
import 'package:user_management/user_model.dart';
import 'package:user_management/user_provider.dart';

class AddUserScreen extends StatefulWidget {
  final int? index;
  final String mode;
  AddUserScreen({super.key, required this.mode, this.index});
  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController fatherNameCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.mode == 'edit'
        ? nameCtrl.text = context
              .read<UserProvider>()
              .users[widget.index!]
              .fullName
        : "";
    widget.mode == 'edit'
        ? emailCtrl.text = context
              .read<UserProvider>()
              .users[widget.index!]
              .email
        : "";
    widget.mode == 'edit' &&
            context.read<UserProvider>().users[widget.index!].fatherName != null
        ? fatherNameCtrl.text = context
              .read<UserProvider>()
              .users[widget.index!]
              .fatherName!
        : "";
    widget.mode == 'edit'
        ? ageCtrl.text = context
              .read<UserProvider>()
              .users[widget.index!]
              .age
              .toString()
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == 'add' ? "Add User" : "Edit User",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Enter User's full name: *",
                  style: GoogleFonts.poppins(),
                ),
              ),
              addUserField("Full name", nameCtrl, TextInputType.text),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Enter User's Email: *",
                  style: GoogleFonts.poppins(),
                ),
              ),
              addUserField("Email", emailCtrl, TextInputType.emailAddress),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Enter Father's name: ",
                  style: GoogleFonts.poppins(),
                ),
              ),
              addUserField("Father's name", fatherNameCtrl, TextInputType.name),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Enter User's age: *",
                  style: GoogleFonts.poppins(),
                ),
              ),
              addUserField("Age", ageCtrl, TextInputType.phone),
              if (widget.mode == 'add')
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Text(
                    "Add User's image: ",
                    style: GoogleFonts.poppins(),
                  ),
                ),
              if (widget.mode == 'add')
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 6,
                    bottom: 10,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadImageScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    child: Text(
                      widget.mode == 'add' ||
                              context
                                      .read<UserProvider>()
                                      .users[widget.index!]
                                      .photo ==
                                  null
                          ? "Add Image"
                          : "Edit Image",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.mode == 'edit') {
                        var emailExists = context
                            .read<UserProvider>()
                            .users
                            .any(
                              (e) =>
                                  emailCtrl.text.toLowerCase() ==
                                      e.email.toLowerCase() &&
                                  e.id !=
                                      context
                                          .read<UserProvider>()
                                          .users[widget.index!]
                                          .id,
                            );
                        if (emailExists) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Email already exists")),
                          );
                          return;
                        }
                      }
                      if (widget.mode == 'add') {
                        var emailExists = context
                            .read<UserProvider>()
                            .users
                            .any(
                              (e) =>
                                  emailCtrl.text.toLowerCase() ==
                                  e.email.toLowerCase(),
                            );
                        if (emailExists) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Email already exists")),
                          );
                          return;
                        }
                      }

                      if (nameCtrl.text.trim().isEmpty ||
                          emailCtrl.text.trim().isEmpty ||
                          ageCtrl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please fill the required details"),
                          ),
                        );
                        return;
                      } else if (int.parse(ageCtrl.text) < 1) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Invalid age")));
                        return;
                      } else {
                        UserModel detail = UserModel(
                          id: widget.mode == 'edit'
                              ? context
                                    .read<UserProvider>()
                                    .users[widget.index!]
                                    .id
                              : null,
                          fullName: nameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          fatherName: fatherNameCtrl.text.isEmpty
                              ? null
                              : fatherNameCtrl.text.trim(),
                          age: int.parse(ageCtrl.text.trim()),
                          photo: widget.mode == 'edit'
                              ? context
                                    .read<UserProvider>()
                                    .users[widget.index!]
                                    .photo
                              : context.read<UserProvider>().imageUrl,
                        );
                        if (widget.mode == 'add') {
                          bool success = await context
                              .read<UserProvider>()
                              .postUserApi(detail);
                          if (!success) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Failed to add user, Please try again.",
                                ),
                              ),
                            );
                            return;
                          }
                        } else {
                          bool success = await context
                              .read<UserProvider>()
                              .updateUserApi(
                                context
                                    .read<UserProvider>()
                                    .users[widget.index!]
                                    .id
                                    .toString(),
                                detail,
                              );
                          if (!success) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Failed to update user, Please try again.",
                                ),
                              ),
                            );
                            return;
                          }
                        }

                        await context.read<UserProvider>().getUserApi();

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 2),
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.mode == 'add' ? "Add User" : "Update User",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
