import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:openjmu/constants/constants.dart';
import 'package:openjmu/pages/main_page.dart';
import 'package:openjmu/pages/home/apps_page.dart';
import 'package:openjmu/pages/home/post_square_list_page.dart';

@FFRoute(
  name: "openjmu://switch-startup",
  routeName: "切换启动页",
)
class SwitchStartUpPage extends StatefulWidget {
  @override
  _SwitchStartUpPageState createState() => _SwitchStartUpPageState();
}

class _SwitchStartUpPageState extends State<SwitchStartUpPage> {
  static final List<List<String>> pageTab = [
    List.from(PostSquareListPageState.tabs),
    List.from(AppsPageState.tabs()),
  ];
  List<List<Map<String, dynamic>>> pageSection = [
    [
      {
        "name": "启动页",
        "pages": List.from(MainPageState.pagesTitle),
        "index": Configs.homeSplashIndex,
      },
    ],
    [
      for (int i = 0; i < pageTab.length; i++)
        {
          "name": MainPageState.pagesTitle[i],
          "pages": pageTab[i],
          "index": Configs.homeStartUpIndex[i],
        }
    ],
  ];

  Widget settingItem(context, index, sectionIndex) {
    final Map<String, dynamic> page = pageSection[sectionIndex][index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: suSetSp(18.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${page["name"]}",
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: suSetSp(26.0),
                        fontWeight: FontWeight.normal,
                      ),
                ),
                Text(
                  "${page["pages"][page["index"]]}",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: suSetSp(18.0),
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            ),
            SvgPicture.asset(
              "assets/icons/arrow-right.svg",
              color: Colors.grey,
              width: suSetWidth(30.0),
              height: suSetWidth(30.0),
            ),
          ],
        ),
      ),
      onTap: () {
        showSelection(context, sectionIndex, page, index).then((list) {
          if (list != null)
            setState(() {
              pageSection = list;
            });
        });
      },
    );
  }

  Widget pageSelectionItem(context, sectionIndex, page, pageIndex, index, selectedIndex) {
    return GestureDetector(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
          borderRadius: BorderRadius.circular(suSetSp(10.0)),
        ),
        child: Center(
          child: Text(
            "${page['pages'][index]}",
            style: TextStyle(
              fontSize: suSetSp(20.0),
            ),
          ),
        ),
      ),
      onTap: () {
        if (page["name"] == "启动页") {
          DataUtils.setHomeSplashIndex(index);
        } else {
          List _list = List.from(Configs.homeStartUpIndex);
          _list[pageIndex] = index;
          DataUtils.setHomeStartUpIndex(_list);
        }
        Navigator.pop(context, newPageSection(sectionIndex, pageIndex, index));
      },
    );
  }

  Future<List<List<Map<String, dynamic>>>> showSelection(context, sectionIndex, page, pageIndex) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: suSetSp(20.0),
              horizontal: suSetSp(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: suSetSp(12.0),
                  ),
                  child: Text(
                    "选择页面",
                    style: TextStyle(
                      fontSize: suSetSp(24.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: suSetSp(6.0),
                  crossAxisSpacing: suSetSp(12.0),
                  childAspectRatio: 2.1,
                  children: <Widget>[
                    for (int i = 0; i < page['pages'].length; i++)
                      pageSelectionItem(
                        context,
                        sectionIndex,
                        page,
                        pageIndex,
                        i,
                        page["index"],
                      ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  List newPageSection(sectionIndex, pageIndex, index) {
    List<List<Map<String, dynamic>>> _section = List.from(pageSection);
    _section[sectionIndex][pageIndex]["index"] = index;
    return _section;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: suSetSp(40.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "启动页设置",
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: suSetSp(40.0),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "设置各个页面的启动页",
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontSize: suSetSp(24.0),
                      ),
                ),
                emptyDivider(height: 20.0),
              ],
            ),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => separator(
                context,
                color: Colors.transparent,
                height: 20.0,
              ),
              itemCount: pageSection.length,
              itemBuilder: (context, sectionIndex) => ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: pageSection[sectionIndex].length,
                itemBuilder: (context, index) => settingItem(
                  context,
                  index,
                  sectionIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
