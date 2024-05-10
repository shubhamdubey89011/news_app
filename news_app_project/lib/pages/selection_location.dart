import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:news_app/constants/constants.dart';

import 'package:news_app/widgets/round_button.dart';

class SelectLocation extends StatefulWidget {
  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  String? countryValue;
  String? stateValue;
  String? cityValue;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color.fromARGB(255, 16, 99, 150),
      appBar: AppBar(
        title: Text('Pick Your City...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectState(
              style:
                  TextStyle(fontSize: 18, color: Colors.white, fontFamily: bold),
              // style: TextStyle(color: Colors.red),
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged: (value) {
                setState(() {
                  stateValue = value;
                });
              },
              onCityChanged: (value) {
                setState(() {
                  cityValue = value;
                });
              },
            ),
           RoundButton(color:  Color.fromARGB(255, 44, 7, 73),
            loading: loading,
              title: 'Check', onTap: () {
               print('country selected is $countryValue');
                  print('State selected is $stateValue');
                  print('City selected is $cityValue');
                  loading = true;
             },),
           
          ],
          
        ),
      ),
      
    );
  }
}
