import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/pages/bookmarks.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/language.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // Import Easy Localization

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();

    final List titles = [
      tr('bookmarks'), // Translate 'bookmarks'
      // tr('language'), // Translate 'language'
      tr('about us'), // Translate 'about us'
      tr('privacy policy'), // Translate 'privacy policy'
      tr('contact us'), // Translate 'contact us'
      tr('facebook page'), // Translate 'facebook page'
      tr('youtube channel'), // Translate 'youtube channel'
      tr('twitter') // Translate 'twitter'
    ];

    final List icons = [
      Feather.bookmark,
      // Feather.globe,
      Feather.info,
      Feather.lock,
      Feather.mail,
      Feather.facebook,
      Feather.youtube,
      Feather.twitter
    ];

    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppName(fontSize: 25.0),
                    Text(
                      'Version: ${sb.appVersion}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30),
                itemCount: titles.length,
                shrinkWrap: true,
                separatorBuilder: (ctx, idx) => Divider(height: 0,),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      titles[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: context.watch<ThemeBloc>().darkTheme == false
                          ? CustomColor().drawerHeaderColorLight
                          : CustomColor().drawerHeaderColorDark,
                      child: Icon(
                        icons[index],
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      if (index == 0) {
                        nextScreen(context, BookmarkPage());
                      } 
                      // else if (index == 1) {
                      //   nextScreenPopup(context, LanguagePopup());
                      // } 
                      else if (index == 2) {
                        AppService().openLinkWithCustomTab(
                            context, Config().ourWebsiteUrl.tr());
                      } else if (index == 3) {
                        AppService().openLinkWithCustomTab(
                            context, Config().privacyPolicyUrl.tr());
                      } else if (index == 4) {
                        AppService().openEmailSupport(context);
                      } else if (index == 5) {
                        AppService().openLink(
                            context, Config.facebookPageUrl.tr());
                      } else if (index == 6) {
                        AppService().openLink(
                            context, Config.youtubeChannelUrl.tr());
                      } else if (index == 7) {
                        AppService().openLink(context, Config.twitterUrl.tr());
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
