import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title ;
  final VoidCallback onTap ;
  final bool loading ;
 final Color color;
  const RoundButton({Key? key ,
    required this.title,
    required this.onTap,
    this.loading = false,required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Center(child: loading ? CircularProgressIndicator(strokeWidth: 3,color: Colors.white,) :
        Text(title, style: TextStyle(color: Colors.white),),),
      ),
    );
  }
}