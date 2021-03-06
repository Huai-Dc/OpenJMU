import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:openjmu/constants/constants.dart';
import 'package:openjmu/widgets/appbar.dart';
import 'package:openjmu/widgets/common_web_page.dart';

@FFRoute(
  name: "openjmu://about",
  routeName: "关于页",
)
class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int tries = 0;
  String currentVersion;

  @override
  void initState() {
    OTAUtils.getCurrentVersion().then((version) {
      currentVersion = version;
      if (mounted) setState(() {});
    });
    super.initState();
  }

  void tryDisplayDebugInfo() {
    tries++;
    if (tries == 10) setState(() {});
  }

  Widget get about => Container(
        padding: EdgeInsets.all(suSetSp(20.0)),
        child: Center(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: tries < 10 ? tryDisplayDebugInfo : null,
                child: Container(
                  margin: EdgeInsets.only(bottom: suSetSp(20.0)),
                  child: SvgPicture.asset(
                    "images/splash_page_logo.svg",
                    width: suSetWidth(200.0),
                    height: suSetWidth(200.0),
                    color: defaultColor,
                  ),
                ),
              ),
              SizedBox(height: suSetHeight(30.0)),
              Container(
                margin: EdgeInsets.only(bottom: suSetSp(12.0)),
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => CommonWebPage.jump(API.homePage, "openjmu"),
                    text: "OpenJmu",
                    style: TextStyle(
                      fontFamily: 'chocolate',
                      color: currentThemeColor,
                      fontSize: suSetSp(50.0),
                    ),
                  ),
                  TextSpan(text: "　v$currentVersion", style: Theme.of(context).textTheme.subtitle),
                ])),
              ),
              SizedBox(height: suSetHeight(20.0)),
              RichText(
                  text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Developed By ",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                  ),
                  TextSpan(
                    text: "openjmu Team",
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontFamily: 'chocolate',
                      fontSize: suSetSp(24.0),
                    ),
                  ),
                  TextSpan(
                      text: " .", style: TextStyle(color: Theme.of(context).textTheme.body1.color)),
                ],
              )),
              SizedBox(height: suSetHeight(80.0)),
            ],
          ),
        ),
      );

  Widget get debugInfo => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SelectableText(
            "———— START DEBUG INFO ————\n"
            "uid: ${currentUser.uid}\n"
            "sid: ${currentUser.sid}\n"
            "workId: ${currentUser.workId}\n"
            "blowfish: ${currentUser.blowfish}\n"
            "————— END DEBUG INFO —————\n",
            textAlign: TextAlign.center,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FixedAppBar(
            title: Text(
              "关于OpenJMU",
              style: Theme.of(context).textTheme.title.copyWith(
                    fontSize: suSetSp(23.0),
                  ),
            ),
            elevation: 0.0,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    about,
                    tries == 10 ? debugInfo : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
