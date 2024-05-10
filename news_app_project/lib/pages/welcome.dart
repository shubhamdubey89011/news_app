import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/pages/done.dart';
import 'package:news_app/pages/sign_up.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/services/phone_auth.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:news_app/widgets/privacy_info.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


import 'package:easy_localization/easy_localization.dart';

class _LanguageSensitiveContent extends StatefulWidget {
  final Widget child;

  const _LanguageSensitiveContent({Key? key, required this.child}) : super(key: key);

  @override
  __LanguageSensitiveContentState createState() => __LanguageSensitiveContentState();
}

class __LanguageSensitiveContentState extends State<_LanguageSensitiveContent> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      child: widget.child,
      supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')], // Add your supported locales here
      path: 'assets/translations', // Path where your translation files are located
      fallbackLocale: Locale('en', 'US'), // Fallback locale
      startLocale: Locale('en', 'US'), // Default locale
      saveLocale: true, // Save locale to memory
      useOnlyLangCode: true, // Use only language code
    );
  }
}


class WelcomePage extends StatefulWidget {
  final String? tag;
  const WelcomePage({Key? key, this.tag}) : super(key: key);
   static rebuild(BuildContext? context) {
    final _WelcomePageState? state =
        context?.findAncestorStateOfType<_WelcomePageState>();
    state?.rebuild();
  }
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool loading = false;
  final GlobalKey _rootWidgetKey = GlobalKey();
  //var phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var scaffoldKey = GlobalKey<ScaffoldState>();
//  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _googleController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _facebookController =
      new RoundedLoadingButtonController();
  // final RoundedLoadingButtonController _appleController =
  //     new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _phoneController =
      new RoundedLoadingButtonController();
  // final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showLanguageSelectionDialog();
      // showLanguageSelectionBottomSheet();
      //  showLanguageToast();
      // showLanguagePopup(); // Show language selection dialog after the frame is rendered
    });
  }

  handleSkip() {
    final sb = context.read<SignInBloc>();
    sb.setGuestUser();
    nextScreen(context, DonePage());
  }

  void showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('English'),
                  onTap: () {
                    _changeLanguage('en');
                    Navigator.of(context).pop();
                     print('english tapped');
                  },
                ),
                ListTile(
                  title: Text('Hindi'),
                  onTap: () {
                    _changeLanguage('hi');
                    Navigator.of(context).pop();
                    print('hindi tapped');
                  },
                ),
                // Add more languages as needed
              ],
            ),
          ),
        );
      },
    );
  }
void _changeLanguage(String languageCode) {
  setState(() {
    EasyLocalization.of(context)!.setLocale(Locale(languageCode));
  });
}

  void rebuild() {
    setState(() {});
  }
  


  handleGoogleSignIn() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(context, tr('check your internet connection!'));
      } else {
        await sb.signInWithGoogle().then((_) {
          if (sb.hasError == true) {
            openSnacbar(context, tr('something is wrong. please try again.'));
            _googleController.reset();
          } else {
            sb.checkUserExists().then((value) {
              if (value == true) {
                sb
                    .getUserDatafromFirebase(sb.uid)
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _googleController.success();
                              handleAfterSignIn();
                            })));
              } else {
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) => sb.increaseUserCount())
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _googleController.success();
                              handleAfterSignIn();
                            }))));
              }
            });
          }
        });
      }
    });
  }

  void handleFacebbokLogin() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(context, tr('check your internet connection!'));
      } else {
        await sb.signInwithFacebook().then((_) {
          if (sb.hasError == true) {
            openSnacbar(context, tr('error fb login'));
            _facebookController.reset();
          } else {
            sb.checkUserExists().then((value) {
              if (value == true) {
                sb
                    .getUserDatafromFirebase(sb.uid)
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _facebookController.success();
                              handleAfterSignIn();
                            })));
              } else {
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) => sb.increaseUserCount())
                    .then((value) => sb.guestSignout().then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _facebookController.success();
                              handleAfterSignIn();
                            })))));
              }
            });
          }
        });
      }
    });
  }

  handleAfterSignIn() {
    setState(() {
      Future.delayed(Duration(milliseconds: 1000)).then((f) {
        gotoNextScreen();
      });
    });
  }

  gotoNextScreen() {
    if (widget.tag == null) {
      nextScreen(context, DonePage());
    } else {
      Navigator.pop(context);
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return _LanguageSensitiveContent(
      child: Scaffold(
        appBar: AppBar(
          actions: [
        
            widget.tag != null
                ? Container()
                : TextButton(
                    onPressed: () => handleSkip(),
                    child: Text(tr('skip'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
    
          ],
        ),
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          bottom: true,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage(Config().splashIcon),
                          height: 130,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                       Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      tr('welcome to'),
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w300,
                                          color:
                                              Theme.of(context).secondaryHeaderColor),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AppName(fontSize: 25),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 5),
                                  child: Text(
                                    tr('sign in to continue'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Theme.of(context).secondaryHeaderColor),
                                  ),
                                )
                              ],
                            ),
                        
                      ],
                    )),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        child: Wrap(
                          children: [
                            Icon(
                              FontAwesome.google,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              tr('Sign In with Google'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        controller: _googleController,
                        onPressed: () => handleGoogleSignIn(),
                        width: MediaQuery.of(context).size.width * 0.80,
                        color: Colors.blueAccent,
                        elevation: 0,
                        //borderRadius: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedLoadingButton(
                        child: Wrap(
                          children: [
                            Icon(
                              FontAwesome.facebook,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              tr('Sign In with Facebook'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        controller: _facebookController,
                        onPressed: () => handleFacebbokLogin(),
                        width: MediaQuery.of(context).size.width * 0.80,
                        color: Colors.indigo,
                        elevation: 0,
                        //borderRadius: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
    
                      RoundedLoadingButton(
                        onPressed: () {
                          nextScreenReplace(context, const PhoneAuthScreen());
                          _phoneController.reset();
                        },
                        controller: _phoneController,
                        successColor: Colors.black,
                        width: MediaQuery.of(context).size.width * 0.80,
                        elevation: 0,
                        borderRadius: 25,
                        color: Colors.black,
                        child: Wrap(
                          children: [
                            Icon(
                              FontAwesomeIcons.phone,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(tr('Sign in with Phone'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
    
                      SizedBox(
                        height: 10,
                      ),
                      // Platform.isAndroid ? Container() : _appleSignInButton()
                    ],
                  ),
                ),
                Text(tr("don't have social accounts?")),
                TextButton(
                  child: Text(
                    tr('continue with email >>'),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    if (widget.tag == null) {
                      nextScreen(context, SignUpPage());
                       print('1 tapped');
                    } else {
                      nextScreen(
                          context,
                          SignUpPage(
                            tag: 'Popup',
                          ));
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                PrivacyInfo(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}








