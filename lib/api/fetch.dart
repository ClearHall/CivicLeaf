import 'package:civicleaf/api/api.dart';
import 'package:civicleaf/model/user.dart';

class FetchModify {
  Api events = new Api('events');
  Api users = new Api('users');
  Future<List<Event>> getEvents() async {
    List<Event> eventList = List();
    for (var a in (await events.getDataCollection()).documents) {
      Event tmp = Event.fromFirestore(a);
      await tmp.getCreator();
      eventList.add(tmp);
    }
    return eventList;
  }

  Future<List<User>> getUsers() async {
    List<User> userList = List();
    for (var a in (await users.getDataCollection()).documents) {
      User tmp = User.fromFirestore(a);
      await tmp.getSignUps();
      userList.add(tmp);
    }
    return userList;
  }
}
