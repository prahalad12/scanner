import '../models/chat_message.dart';

const List<ChatMessage> mockChats = [
  ChatMessage(
    name: 'John Doe',
    lastMessage: 'Hi, is it available?',
    itemName: 'Sony WH-1000XM5 Headphones',
    price: '£190',
    time: '10:30 AM',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100',
    unreadCount: 2,
    isOnline: true,
  ),
  ChatMessage(
    name: 'Sarah Wilson',
    lastMessage: "Thank you! I'll buy it.",
    itemName: 'STCW Prep Book Bundle',
    price: '£28',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1523050854058-8df90110c9a1?w=100',
    unreadCount: 1,
  ),
  ChatMessage(
    name: 'Mike Smith',
    lastMessage: 'Can you do £30?',
    itemName: 'Grisport Safety Boots Size 9',
    price: '£65',
    time: 'Yesterday',
    avatarUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1606890658317-7d4e2e5928f9?w=100',
    isOnline: true,
  ),
  ChatMessage(
    name: 'Jessica Lee',
    lastMessage: 'Okay, sounds good!',
    itemName: 'Female Interior Uniform Set',
    price: '£180',
    time: '20 May',
    avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1558618047-3c8c76ca3320?w=100',
  ),
  ChatMessage(
    name: 'David Brown',
    lastMessage: 'When can we meet?',
    itemName: 'Musto Offshore Jacket L',
    price: '£230',
    time: '19 May',
    avatarUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1542272604-787c3835535a?w=100',
  ),
  ChatMessage(
    name: 'Chris Martin',
    lastMessage: "Perfect, I'll take it.",
    itemName: 'iPad Pro 12.9" + Case',
    price: '£350',
    time: '18 May',
    avatarUrl: 'https://randomuser.me/api/portraits/men/83.jpg',
    itemImageUrl:
        'https://images.unsplash.com/photo-1592899678249-89124f4b1e5a?w=100',
  ),
];

const Map<String, List<BubbleMessage>> mockChatHistory = {
  'John Doe': [
    BubbleMessage(
      text: 'Hey! Are the Sony headphones still available?',
      isMine: false,
      time: '10:20 AM',
    ),
    BubbleMessage(
      text: 'Yes, still available. Great condition, barely used.',
      isMine: true,
      time: '10:22 AM',
      status: MessageStatus.read,
    ),
    BubbleMessage(
      text: 'How much are you asking for them?',
      isMine: false,
      time: '10:24 AM',
    ),
    BubbleMessage(
      text: 'Listed at £190 but open to sensible offers.',
      isMine: true,
      time: '10:25 AM',
      status: MessageStatus.read,
    ),
    BubbleMessage(text: 'Hi, is it available?', isMine: false, time: '10:30 AM'),
  ],
  'Sarah Wilson': [
    BubbleMessage(
      text: 'Hi! Is the STCW book bundle available?',
      isMine: false,
      time: 'Yesterday',
    ),
    BubbleMessage(text: 'Yes it is. Only £28.', isMine: true, time: 'Yesterday'),
    BubbleMessage(
      text: 'Perfect, that is exactly what I need.',
      isMine: false,
      time: 'Yesterday',
    ),
    BubbleMessage(
      text: 'It is in great condition too, no markings inside.',
      isMine: true,
      time: 'Yesterday',
    ),
    BubbleMessage(
      text: "Thank you! I'll buy it.",
      isMine: false,
      time: 'Yesterday',
    ),
  ],
  'Mike Smith': [
    BubbleMessage(
      text: 'Are the safety boots still available?',
      isMine: false,
      time: 'Yesterday',
    ),
    BubbleMessage(
      text: "Yes. £65 and they're yours.",
      isMine: true,
      time: 'Yesterday',
    ),
    BubbleMessage(text: 'Can you do £30?', isMine: false, time: 'Yesterday'),
  ],
  'Jessica Lee': [
    BubbleMessage(
      text: 'Hey, is the uniform set still available?',
      isMine: false,
      time: '20 May',
    ),
    BubbleMessage(
      text: 'Yes. It is very good condition.',
      isMine: true,
      time: '20 May',
    ),
    BubbleMessage(
      text: 'Okay, sounds good!',
      isMine: false,
      time: '20 May',
    ),
  ],
  'David Brown': [
    BubbleMessage(
      text: 'Hi! Still selling the Musto jacket?',
      isMine: false,
      time: '19 May',
    ),
    BubbleMessage(
      text: 'Yes. Waterproof and ready to go.',
      isMine: true,
      time: '19 May',
    ),
    BubbleMessage(text: 'When can we meet?', isMine: false, time: '19 May'),
  ],
  'Chris Martin': [
    BubbleMessage(
      text: 'Hi, is the iPad still available?',
      isMine: false,
      time: '18 May',
    ),
    BubbleMessage(
      text: 'Yes. It comes with the case too.',
      isMine: true,
      time: '18 May',
    ),
    BubbleMessage(
      text: "Perfect, I'll take it.",
      isMine: false,
      time: '18 May',
    ),
  ],
};
