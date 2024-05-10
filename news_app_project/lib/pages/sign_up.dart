import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/pages/done.dart';
import 'package:news_app/pages/sign_in.dart';
import 'package:news_app/screens/register_screen.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/icons.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:news_app/widgets/privacy_info.dart';
import 'package:news_app/widgets/round_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SignUpPage extends StatefulWidget {
  final String? tag;
  SignUpPage({Key? key, this.tag}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var countryCtrl = TextEditingController();
  var stateCtrl = TextEditingController();
  var cityCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? countryValue;
  String? stateValue;
  String? cityValue;

  late String email;
  late String pass;
  String? name;
  String? loc;
  bool signUpStarted = false;
  bool signUpCompleted = false;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;
      });
    }
  }

  Future handleSignUpwithEmailPassword() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await AppService().checkInternet().then((hasInternet) {
        if (hasInternet == false) {
          openSnacbar(context, 'no internet');
        } else {
          setState(() {
            signUpStarted = true;
          });
          sb.signUpwithEmailPassword(name, email, pass, countryValue, stateValue, cityValue).then((_) async {
            if (sb.hasError == false) {
              sb.getTimestamp().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value) => sb.guestSignout().then((value) => sb
                      .saveDataToSP()
                      .then((value) => sb.setSignIn().then((value) {
                            setState(() {
                              signUpCompleted = true;
                            });
                            afterSignUp();
                          })))));
            } else {
              setState(() {
                signUpStarted = false;
              });
              openSnacbar(context, sb.errorCode);
            }
          });
        }
      });
    }
  }

  afterSignUp() {
    if (widget.tag == null) {
      nextScreenReplace(context, DonePage());
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    IconButton(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.keyboard_backspace),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text('sign up',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  ],
                ),
                
                // Text('follow the simple steps',
                //     style: TextStyle(
                //         fontSize: 14,
                //         fontWeight: FontWeight.w500,
                //         color: Theme.of(context).secondaryHeaderColor)),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    //prefixIcon: Icon(Icons.person)
                  ),
                  validator: (String? value) {
                    if (value!.length == 0) return "Name can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // TextFormField(
                //   controller: locationCtrl,
                //   keyboardType: TextInputType.text,
                //   decoration: InputDecoration(
                //     labelText: 'Location',
                //     hintText: 'Enter Location',
                //     //  prefixIcon: Icon(Icons.location_city),
                //   ),
                //   validator: (String? value) {
                //     if (value!.length == 0) return "Location can't be empty";
                //     return null;
                //   },
                //   onChanged: (String value) {
                //     setState(() {
                //       loc = value;
                //     });
                //   },
                // ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    labelText: 'Email Address',
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value!.length == 0) return "Email can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passCtrl,
                  obscureText: offsecureText,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    suffixIcon: IconButton(
                        icon: lockIcon,
                        onPressed: () {
                          lockPressed();
                        }),
                  ),
                  validator: (String? value) {
                    if (value!.length == 0) return "Password can't be empty";
                    return null;
                  },
                  onChanged: (String value) {
                    setState(() {
                      pass = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
          children: [
            SelectState(
              // style: TextStyle(color: Colors.red),
              onCountryChanged: (String value) {
              setState(() {
                // controller:countryCtrl.value;
                countryValue = value;
              });
            },
            onStateChanged:(String value) {
              setState(() {
                stateValue = value;
              });
            },
             onCityChanged:(String value) {
              setState(() {
                cityValue = value;
              });
            },
            
            ),
          
          ],
        ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Theme.of(context).primaryColor)),
                      child: signUpStarted == false
                          ? Text(
                              'sign up',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )
                          : signUpCompleted == false
                              ? CircularProgressIndicator(
                                  backgroundColor: Colors.white)
                              : Text('sign up successful!',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                      onPressed: () {
                        handleSignUpwithEmailPassword();
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('already have an account?'),
                    TextButton(
                      child: Text(
                        'sign in',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        if (widget.tag == null) {
                          nextScreenReplace(context, SignInPage());
                        } else {
                          nextScreenReplace(
                              context,
                              SignInPage(
                                tag: 'Popup',
                              ));
                        }
                      },
                    )
                  ],
                ),
              
                SizedBox(
                  height: 10,
                ),
                RoundButton(color:  Color.fromARGB(255, 44, 7, 73),
                    title: 'Sign With Mobile Number',
                    loading: loading,
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                      setState(() {
                        loading = true;
                      });
                    })),
                                    SizedBox(
                  height: 30,
                ),
                PrivacyInfo()
              ],
            ),
          ),
        ));
  }
}
