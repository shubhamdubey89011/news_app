import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
  //import 'package:get/get.dart';
import 'package:news_app/pages/intro.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:news_app/utils/utils.dart';
import 'package:news_app/widgets/auth_widget.dart';
import 'package:news_app/widgets/round_button.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId ;
  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false ;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 80,),

            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '6 digit code'
              ),
            ),
            SizedBox(height: 80,),
            RoundButton(color:  Color.fromARGB(255, 44, 7, 73),title: 'Verify',loading: loading, onTap: ()async{

              setState(() {
                loading = true ;
              });
              final crendital = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId, 
                  smsCode: verificationCodeController.text.toString()
              );
              
              try{
                
                await auth.signInWithCredential(crendital);
                
                Navigator.push(context, MaterialPageRoute(builder: (context) => IntroPage()));
                
              }catch(e){
                setState(() {
                  loading = false ;
                });
                Utils().toastMessage(e.toString());
              }
            })

          ],
        ),
      ),
    );
  }
}
