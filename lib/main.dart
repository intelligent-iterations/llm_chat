import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:llm_chat/model/llm_chat_message.dart';
import 'package:llm_chat/model/llm_style.dart';

List<LlmChatMessage> chats = [
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 3000,
    message: "Welcome to ChatGPT! How can I help you today?",
    type: "system",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and ask your question.",
    type: "assistant",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 2000,
    message: "Hello! I have a question about Dart.",
    type: "user",
  ),
  LlmChatMessage(
    time: DateTime.now().millisecondsSinceEpoch - 1000,
    message: "Of course! Please go ahead and last",
    type: "assistant",
  ),
];

main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Example(),
    );
  }
}

final controller = TextEditingController();
final scrollController = ScrollController();

class _Example extends StatefulWidget {
  @override
  State<_Example> createState() => _ExampleState();
}

class _ExampleState extends State<_Example> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LLMChat(
              scrollController: scrollController,
              awaitingResponse: true,
              messages: chats,
              controller: controller,
              onSubmit: (newMessage) {
                chats.add(LlmChatMessage.user(message: newMessage));
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}

class LLMChat extends StatelessWidget {
  const LLMChat({
    required this.messages,
    required this.awaitingResponse,
    required this.controller,
    required this.onSubmit,
    required this.scrollController,
    this.style,
    this.messageBuilder,
    this.boxDecorationBasedOnMessage,
    this.messagePadding,
    this.chatPadding,
    this.loadingWidget,
    super.key,
  });

  final EdgeInsetsGeometry? messagePadding;
  final EdgeInsetsGeometry? chatPadding;

  final BoxDecoration Function(LlmChatMessage)? boxDecorationBasedOnMessage;
  final LlmMessageStyle? style;

  final List<LlmChatMessage> messages;
  final bool awaitingResponse;
  final Widget Function(LlmChatMessage message)? messageBuilder;
  final ScrollController? scrollController;

  final TextEditingController controller;
  final Function(String) onSubmit;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    final _messages = messages.reversed.toList();

    final _style = style ??
        LlmMessageStyle(
          userColor: Colors.grey,
          assistantColor: Colors.blue,
        );

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length + 1,
            controller: scrollController,
            padding: chatPadding ?? const EdgeInsets.only(bottom: 20),
            itemBuilder: (_, i) {
              if (i == _messages.length) {
                if (awaitingResponse) {
                  return loadingWidget ?? CircularProgressIndicator();
                }
               return Container();
              }

              final builder = messageBuilder;
              if (builder != null) {
                return messageBuilder!(_messages[i]);
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LlmChatMessageItem(
                    message: _messages[i],
                    style: _style,
                  ),
                );
              }
            },
          ),
        ),
        LLmChatTextInput(
          controller: controller,
          onSubmit: (text) {
            onSubmit(text);
            scrollController?.jumpTo(0);
          },
        ),


      ],
    );
  }
}

class LLmChatTextInput extends StatelessWidget {
  const LLmChatTextInput({
    required this.controller,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              onSubmit(controller.text);
              controller.clear();
            },
          )
        ],
      ),
    );
  }
}

class LlmChatMessageItem extends StatelessWidget {
  const LlmChatMessageItem({
    this.boxDecorationBasedOnMessage,
    this.messagePadding,
    required this.message,
    required this.style,
  });

  final LlmMessageStyle style;
  final LlmChatMessage message;
  final BoxDecoration Function(LlmChatMessage)? boxDecorationBasedOnMessage;
  final EdgeInsetsGeometry? messagePadding;

  @override
  Widget build(BuildContext context) {
    if ('${message.type}' == 'user' || message.type == 'assistant') {
      BoxDecoration decoration = boxDecorationBasedOnMessage == null
          ? BoxDecoration(
              color: _getColor(), borderRadius: BorderRadius.circular(12))
          : boxDecorationBasedOnMessage!(message);

      return Align(
        alignment: message.type == 'user'
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        child: Container(
          padding: messagePadding ??
              EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
          decoration: decoration,
          child: Text(
            '${message.message}',
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Color _getColor() {
    switch (message.type) {
      case 'user':
        return style.userColor;
      default:
        return style.assistantColor;
    }
  }
}
