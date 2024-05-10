import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:news_app/models/theme_model.dart';
import 'package:news_app/widgets/localization_service.dart';
import 'package:path_provider/path_provider.dart';
import 'constants/constants.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_analytics/firebase_analytics.dart';
  //import 'package:get/get.dart';
import 'package:news_app/blocs/admin_bloc.dart';
import 'package:news_app/blocs/internet_provider.dart';
import 'package:news_app/blocs/notification1_bloc.dart';
import 'package:news_app/pages/splash.dart';
import 'package:provider/provider.dart';
import 'blocs/bookmark_bloc.dart';
import 'blocs/categories_bloc.dart';
import 'blocs/category_tab1_bloc.dart';
import 'blocs/category_tab2_bloc.dart';
import 'blocs/category_tab3_bloc.dart';
import 'blocs/category_tab4_bloc.dart';
import 'blocs/comments_bloc.dart';
import 'blocs/featured_bloc.dart';
import 'blocs/notification_bloc.dart';
import 'blocs/popular_articles_bloc.dart';
import 'blocs/recent_articles_bloc.dart';
import 'blocs/related_articles_bloc.dart';
import 'blocs/search_bloc.dart';
import 'blocs/sign_in_bloc.dart';
import 'blocs/tab_index_bloc.dart';
import 'blocs/theme_bloc.dart';
import 'blocs/videos_bloc.dart';
import 'provider/auth_provider.dart';

import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future<void> changeLanguage(String languageCode) async {
  final String jsonString = await rootBundle
      .loadString('assets/translations/$languageCode.json');
  LocalizationService().loadJson(jsonString);
  // Optionally, you can update the UI to reflect the language change
}
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox(Constants.notificationTag);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark
  ));
 
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('hi'),
        // Add other supported locales here
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: Locale('en'),
       useOnlyLangCode: true,
      child: MyApp(),
    ),
  );
  
}



final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver firebaseObserver =
    FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                  create: (context) => AuthProvider()),
              ChangeNotifierProvider(
                create: ((context) => InternetProvider()),
              ),
              ChangeNotifierProvider<AdminBloc>(
                  create: (context) => AdminBloc()),
              ChangeNotifierProvider<SignInBloc>(
                create: (context) => SignInBloc(),
              ),
              ChangeNotifierProvider<CommentsBloc>(
                create: (context) => CommentsBloc(),
              ),
              ChangeNotifierProvider<BookmarkBloc>(
                create: (context) => BookmarkBloc(),
              ),
              ChangeNotifierProvider<SearchBloc>(
                  create: (context) => SearchBloc()),
              ChangeNotifierProvider<FeaturedBloc>(
                  create: (context) => FeaturedBloc()),
              ChangeNotifierProvider<PopularBloc>(
                  create: (context) => PopularBloc()),
              ChangeNotifierProvider<RecentBloc>(
                  create: (context) => RecentBloc()),
              ChangeNotifierProvider<CategoriesBloc>(
                  create: (context) => CategoriesBloc()),
              ChangeNotifierProvider<RelatedBloc>(
                  create: (context) => RelatedBloc()),
              ChangeNotifierProvider<TabIndexBloc>(
                  create: (context) => TabIndexBloc()),
              ChangeNotifierProvider<NotificationBloc>(
                  create: (context) => NotificationBloc()),
              ChangeNotifierProvider<NotificationBloc1>(
                  create: (context) => NotificationBloc1()),
              ChangeNotifierProvider<VideosBloc>(
                  create: (context) => VideosBloc()),
              ChangeNotifierProvider<CategoryTab1Bloc>(
                  create: (context) => CategoryTab1Bloc()),
              ChangeNotifierProvider<CategoryTab2Bloc>(
                  create: (context) => CategoryTab2Bloc()),
              ChangeNotifierProvider<CategoryTab3Bloc>(
                  create: (context) => CategoryTab3Bloc()),
              ChangeNotifierProvider<CategoryTab4Bloc>(
                  create: (context) => CategoryTab4Bloc()),
            ],
            child: MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                navigatorObservers: [firebaseObserver],
                theme: ThemeModel().lightMode,
                darkTheme: ThemeModel().darkMode,
                themeMode:
                    mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: SplashPage()),
          );
        },
      ),
    );
  }
}





