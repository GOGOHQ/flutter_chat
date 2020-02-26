import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_chat/Common/staticMembers.dart';
import 'package:flutter_chat/Model/chatContentModel.dart';
import 'package:flutter_chat/Provider/bottomRowAnimaProvider.dart';
import 'package:flutter_chat/Provider/chatListProvider.dart';
import 'package:flutter_chat/Provider/chooseFileProvider.dart';
import 'package:flutter_chat/Provider/gaodeMapProvider.dart';
import 'package:flutter_chat/Provider/jPushProvider.dart';
import 'package:flutter_chat/Provider/signalRProvider.dart';
import 'package:flutter_chat/Provider/themeProvider.dart';
import 'package:flutter_chat/Provider/voiceRecoderProvider.dart';
import 'package:flutter_chat/Provider/xfVoiceProvider.dart';
import 'package:flutter_chat/Router/fade_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'chatDetail/chatDetail.dart';
import 'mapPage/gaodeMapPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime _lastPressedAt;

  PageController controller = PageController();
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    List<PopupMenuEntry> menus = List<PopupMenuEntry>();
    return new WillPopScope(
      onWillPop: () async {
        return onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton(
              onSelected: (value) {
                themeProvider.changeSelColor(value);
              },
              icon: Icon(Icons.color_lens),
              itemBuilder: (context) {
                return buildPopUpMenus(menus);
              }),
          title: Text("简单聊天"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {},
            ),
          ],
        ),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => ChatListProvider(),
              ),
            ],
            child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    curIndex = index;
                  });
                },
                children: [
                  ChatList(),
                  ChatList(),
                ])),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: curIndex,
            onTap: (index) {
              controller.animateToPage(index,
                  duration: Duration(milliseconds: 200), curve: Curves.ease);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.chat_bubble,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('聊天')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.face,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.face,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('朋友圈')),
            ]),
      ),
    );
  }

  buildPopUpMenus(List<PopupMenuEntry> menus) {
    menus.add(PopupMenuItem(
      value: THEMECOLORMAPPING.BLUEGREY,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.blueGrey,
          ),
          Text("灰蓝"),
        ],
      ),
    ));
    menus.add(PopupMenuDivider(
      height: 1,
    ));
    menus.add(PopupMenuItem(
      value: THEMECOLORMAPPING.RED,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          Text("红色"),
        ],
      ),
    ));
    menus.add(PopupMenuDivider(
      height: 1,
    ));
    menus.add(PopupMenuItem(
      value: THEMECOLORMAPPING.PURPLE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.purple,
          ),
          Text("紫色"),
        ],
      ),
    ));
    menus.add(PopupMenuDivider(
      height: 1,
    ));
    menus.add(PopupMenuItem(
      value: THEMECOLORMAPPING.YELLOW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            Icons.favorite,
            color: Colors.yellow,
          ),
          Text("黄色"),
        ],
      ),
    ));

    return menus;
  }

  onWillPop() {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 3)) {
      BotToast.showText(
          text: "再次返回退出简单聊天",
          textStyle: TextStyle(fontSize: 12, color: Colors.white));
      _lastPressedAt = DateTime.now();
      return false;
    } else {
      print('debug: 退出程序');
      return true;
    }
  }
}

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatListProvider provider = Provider.of<ChatListProvider>(context);
    if (provider == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      List<ChatContentModel> chats = provider.chats;
      return Container(
        child: ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (_, index) {
              return ChatItem(
                chat: chats[index],
                index: index,
              );
            }),
      );
    }
  }
}

class ChatItem extends StatelessWidget {
  final ChatContentModel chat;
  final int index;
  ChatItem({this.chat, this.index});
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => XFVoiceProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => VoiceRecoderProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => BottomRowAnimProvider(context),
                  ),
                ],
                child: DetailPage(
                  index: index,
                ));
          }));
        },
        child: Material(
          child: Hero(
            tag: index,
            child: Material(
              child: ListTile(
                leading: new Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                        image: NetworkImage(chat.userIds[0].avatarUrl),
                        fit: BoxFit.cover),
                  ),
                ),
                title: Text(chat.userIds[0].userName),
                subtitle: Text(chat.lastContent),
                trailing: Text(chat.lastUpdateTime),
              ),
            ),
          ),
        ));
  }
}
