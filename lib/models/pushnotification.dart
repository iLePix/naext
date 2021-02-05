class PushNotification<T> {

  String title;

  String body;

  T payload;

  PushNotification.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return;
    title = json['title'];
    body = json['body'];
    payload = json['payload'];

    if (json['data'] != null) {
      if (title == null) {
        title = json["data"]["title"];
      }

      if (body == null) {
        body = json["data"]["body"];
      }

      if (payload == null) {
        payload = json["data"]["payload"];
      }
    }
  }
}