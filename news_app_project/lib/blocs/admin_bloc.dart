
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class AdminBloc extends ChangeNotifier {
  
  final FirebaseFirestore firestore = FirebaseFirestore.instance;



  bool? _isSignedIn;
  bool _isAdmin = false;
  List _categories = [];
  List get categories => _categories;

   bool? get isSignedIn => _isSignedIn;
  bool get isAdmin => _isAdmin;

  Future getCategories ()async{

    await firestore.collection('categories').limit(1).get().then((value)async{
      if(value.size != 0){
        QuerySnapshot snap = await firestore.collection('categories').get();
        List d = snap.docs;
        _categories.clear();
        d.forEach((element) {
        _categories.add(element['name']);
      }
      
      );

    }else{
      _categories.clear();
    }

    notifyListeners();

    });
    
  }


}
