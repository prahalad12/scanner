import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/mock_chats.dart';
import '../models/chat_message.dart';
import '../theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatMessage chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _typingController;
  late List<BubbleMessage> _messages;
  bool _showItemCard = true;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messages = List<BubbleMessage>.from(
      mockChatHistory[widget.chat.name] ?? const <BubbleMessage>[],
    );
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = false}) {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }
    _scrollController.jumpTo(target);
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(
        BubbleMessage(
          text: text,
          isMine: true,
          time: _currentTime(),
          status: MessageStatus.sent,
        ),
      );
      _inputController.clear();
      _isTyping = true;
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom(animated: true));

    Future.delayed(Duration(milliseconds: 1200 + Random().nextInt(800)), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          BubbleMessage(
            text: _autoReply(),
            isMine: false,
            time: _currentTime(),
          ),
        );
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _scrollToBottom(animated: true));
    });
  }

  String _autoReply() {
    const replies = [
      'Sure, sounds good.',
      'Let me check and get back to you.',
      'That works for me.',
      'Okay, when are you free to meet?',
      'Great, looking forward to it.',
      'Could you do a bit lower?',
      "Perfect, I'll take it.",
      'Is it still in good condition?',
    ];
    return replies[Random().nextInt(replies.length)];
  }

  String _currentTime() {
    final now = TimeOfDay.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YwcTheme.surface,
      body: Column(
        children: [
          _buildAppBar(),
          if (_showItemCard) _buildItemCard(),
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YwcTheme.navy, YwcTheme.navyLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(width: 8),
              _NetworkAvatar(url: widget.chat.avatarUrl, size: 42),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.chat.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.chat.isOnline ? 'Online now' : 'Usually replies soon',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.call_outlined),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 10, 12, 2),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: YwcTheme.surface2,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: CachedNetworkImage(
                  imageUrl: widget.chat.itemImageUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFE8EDFF),
                    child: Icon(Icons.image_outlined, color: YwcTheme.navy),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.itemName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: YwcTheme.text1,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.chat.price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: YwcTheme.teal,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: YwcTheme.navy,
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Offer'),
            ),
            IconButton(
              onPressed: () => setState(() => _showItemCard = false),
              icon: const Icon(Icons.close_rounded),
              color: YwcTheme.text3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        itemCount: _messages.length + (_isTyping ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isTyping && index == _messages.length) {
            return _buildTypingIndicator();
          }
          final message = _messages[index];
          final showAvatar = !message.isMine &&
              (index == _messages.length - 1 ||
                  _messages[index + 1].isMine);
          return _buildBubble(message, index, showAvatar);
        },
      ),
    );
  }

  Widget _buildBubble(BubbleMessage message, int index, bool showAvatar) {
    final isFirst =
        index == 0 || _messages[index - 1].isMine != message.isMine;
    final isLast = index == _messages.length - 1 ||
        _messages[index + 1].isMine != message.isMine;

    return TweenAnimationBuilder<double>(
      key: ValueKey('${message.text}-$index'),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 8 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: isFirst ? 6 : 2,
          bottom: isLast ? 6 : 2,
          left: message.isMine ? 64 : 0,
          right: message.isMine ? 0 : 64,
        ),
        child: Row(
          mainAxisAlignment:
              message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isMine) ...[
              showAvatar
                  ? _NetworkAvatar(url: widget.chat.avatarUrl, size: 30)
                  : const SizedBox(width: 30),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: message.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMine ? YwcTheme.navy : YwcTheme.surface2,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(message.isMine ? 18 : 4),
                        bottomRight: Radius.circular(message.isMine ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: message.isMine
                                ? Colors.white
                                : YwcTheme.text1,
                            height: 1.35,
                          ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: YwcTheme.text3,
                            ),
                      ),
                      if (message.isMine) ...[
                        const SizedBox(width: 4),
                        _statusIcon(message.status),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(MessageStatus status) {
    return switch (status) {
      MessageStatus.sent =>
        Icon(Icons.check_rounded, size: 13, color: YwcTheme.text3),
      MessageStatus.delivered =>
        Icon(Icons.done_all_rounded, size: 13, color: YwcTheme.text3),
      MessageStatus.read =>
        const Icon(Icons.done_all_rounded, size: 13, color: YwcTheme.teal),
    };
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          _NetworkAvatar(url: widget.chat.avatarUrl, size: 30),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: YwcTheme.surface2,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _typingController,
                  builder: (_, __) {
                    final value = sin(
                      (_typingController.value * 2 * pi) - index * 0.3 * pi,
                    );
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      width: 7,
                      height: 7 + (value * 3).clamp(0.0, 3.0),
                      decoration: BoxDecoration(
                        color: YwcTheme.teal.withValues(
                          alpha: (0.45 + value * 0.25).clamp(0.2, 0.8),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      decoration: BoxDecoration(
        color: YwcTheme.surface2,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton.filledTonal(
                onPressed: () {},
                icon: const Icon(Icons.attach_file_rounded),
                color: YwcTheme.navy,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 42, maxHeight: 120),
                  child: TextField(
                    controller: _inputController,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: YwcTheme.navy,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NetworkAvatar extends StatelessWidget {
  final String url;
  final double size;

  const _NetworkAvatar({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => ColoredBox(
            color: const Color(0xFFE8EDFF),
            child: Icon(Icons.person, color: YwcTheme.navy, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
