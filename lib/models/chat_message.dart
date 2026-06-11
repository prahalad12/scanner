enum MessageStatus { sent, delivered, read }

class ChatMessage {
  final String name;
  final String lastMessage;
  final String itemName;
  final String price;
  final String time;
  final String avatarUrl;
  final String itemImageUrl;
  final int unreadCount;
  final bool isOnline;

  const ChatMessage({
    required this.name,
    required this.lastMessage,
    required this.itemName,
    required this.price,
    required this.time,
    required this.avatarUrl,
    required this.itemImageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class BubbleMessage {
  final String text;
  final bool isMine;
  final String time;
  final MessageStatus status;

  const BubbleMessage({
    required this.text,
    required this.isMine,
    required this.time,
    this.status = MessageStatus.read,
  });
}
