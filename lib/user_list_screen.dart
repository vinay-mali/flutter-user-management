import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:user_management/add_user_screen.dart';
import 'package:user_management/user_provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<bool> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = context.read<UserProvider>().getUserApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<UserProvider>().getUserApi();
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Refreshed"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.replay_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 13,
                  left: 17,
                  right: 10,
                ),
                child: Text(
                  "Total users: ${context.watch<UserProvider>().usersTotal ?? '0'}",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
              ),

              FutureBuilder(
                future: _userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (context.watch<UserProvider>().users.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: context.watch<UserProvider>().users.length,
                        itemBuilder: (context, index) {
                          var data = context.watch<UserProvider>().users[index];
                          return Card(
                            color: Colors.white,
                            elevation: 1,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddUserScreen(
                                      mode: 'edit',
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Are you sure you want to delete this user?",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: GoogleFonts.poppins(),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            bool success = await context
                                                .read<UserProvider>()
                                                .deleteUserApi(
                                                  context
                                                      .read<UserProvider>()
                                                      .users[index]
                                                      .id!,
                                                );
                                            if (!success) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).clearSnackBars();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Failed to delete user, Please try again.",
                                                  ),
                                                ),
                                              );
                                            }

                                            await context
                                                .read<UserProvider>()
                                                .getUserApi();
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text(
                                            "Delete",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              title: Text(
                                data.fullName,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 2, spreadRadius: 0.5),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 33,
                                  backgroundImage: data.photo != null
                                      ? NetworkImage(data.photo!)
                                      : AssetImage(
                                          "assets/images/no_profile_photo.png",
                                        ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.email,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    data.fatherName != null
                                        ? "Father's name: ${data.fatherName}"
                                        : "Father's name: Not Available",
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                    "Age: ${data.age.toString()}",
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 160),

                          Text("No user present"),
                          SizedBox(height: 10),
                          Icon(
                            Icons.note_alt_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text("Click on + icon to add User"),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserScreen(mode: 'add')),
          );
        },
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
