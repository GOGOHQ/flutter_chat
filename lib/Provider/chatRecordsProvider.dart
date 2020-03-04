//  import 'package:flutter/material.dart';
//  import 'package:flutter_chat/Model/chatModel.dart';
//  import 'package:flutter_chat/Utils/sqliteHelper.dart';

//  class ChatRecordsProvider with ChangeNotifier {
//    List<ChatModel> chats = List<ChatModel>();
//    String loginId;
//    String otherId;
//    bool ifDisposed = false;
//    int offset = 0; //chats count rendered
//    ChatRecordsProvider(String loginUser, String toUser) {
//      loginId = loginUser;
//      otherId = toUser;
//      getChatRecordsByUserId();
//    }
//    getChatRecordsByUserId() async {
//      List<ChatModel> chatsNewAdd =
//          await SqliteHelper().getChatRecordsByUserId(loginId, otherId, offset);
//      chats.addAll(chatsNewAdd);
//      notifyListeners();
//    }

//    updateChatRecordsInChat(ChatModel chat) {
//      chats.insert(0, chat);
//      notifyListeners();
//    }

//    @override
//    void dispose() {
//      // TODO: implement dispose
//      ifDisposed = true;
//      super.dispose();
//    }
//  }
