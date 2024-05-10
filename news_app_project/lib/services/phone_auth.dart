import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/internet_provider.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/pages/intro.dart';
import 'package:news_app/pages/welcome.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:provider/provider.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final formKey = GlobalKey<FormState>();
  // controller -> phone, email, name, otp code
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            nextScreenReplace(context, const WelcomePage());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: AssetImage(Config().splashIcon),
                    height: 50,
                    width: 50),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Phone Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle),
                      hintText: "Adam Smith",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email address cannot be empty";
                    }
                    return null;
                  },
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      hintText: "abc@gmail.com",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Phone Number cannot be empty";
                    }
                    return null;
                  },
                  controller: phoneController,
                  textInputAction: TextInputAction.done,keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone),
                      hintText: "+1-1234567890",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey))),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    login(context, phoneController.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  child: const Text("Register"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context, String mobile) async {
    final sp = context.read<SignInBloc>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnacbar(context, "Check your internet connection");
    } else {
      if (formKey.currentState!.validate()) {
        FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: mobile,
            verificationCompleted: (AuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
            },
            verificationFailed: (FirebaseAuthException e) {
              openSnacbar(
                context,
                e.toString(),
              );
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Enter Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(keyboardType: TextInputType.phone,
                            controller: otpCodeController,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.code),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: Colors.grey))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final code = otpCodeController.text.trim();
                              AuthCredential authCredential =
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: code);
                              User user = (await FirebaseAuth.instance
                                      .signInWithCredential(authCredential))
                                  .user!;
                              // save the values
                              sp.phoneNumberUser(user, emailController.text,
                                  nameController.text, phoneController.text);
                              // checking whether user exists,
                              sp.checkUserExists().then((value) async {
                                if (value == true) {
                                  // user exists
                                  await sp.getUserDatafromFirebase(sp.uid).then(
                                      (value) => sp.getDataFromSp().then(
                                          (value) =>
                                              sp.setSignIn().then((value) {
                                                nextScreenReplace(
                                                    context, IntroPage());
                                              })));
                                } else {
                                  // user does not exist
                                  await sp.saveToFirebase().then((value) => sp
                                      .saveDataToSP()
                                      .then((value) =>
                                          sp.setSignIn().then((value) {
                                            nextScreenReplace(
                                                context, IntroPage());
                                          })));
                                }
                              });
                            },
                            child: const Text("Confirm"),
                          )
                        ],
                      ),
                    );
                  });
            },
            codeAutoRetrievalTimeout: (String verification) {});
      }
    }
  }
}
