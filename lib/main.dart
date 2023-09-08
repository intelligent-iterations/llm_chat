import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LLMChat(
              showSystemMessage: true,
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

class LLMChat extends StatefulWidget {
  const LLMChat({
    required this.messages,
    required this.awaitingResponse,
    required this.controller,
    required this.onSubmit,
    required this.scrollController,
    required this.showSystemMessage,
    this.style,
    this.messageBuilder,
    this.boxDecorationBasedOnMessage,
    this.messagePadding,
    this.chatPadding,
    this.loadingWidget,
    super.key,
  });

  final bool showSystemMessage;

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
  State<LLMChat> createState() => _LLMChatState();
}

class _LLMChatState extends State<LLMChat> {
  @override
  Widget build(BuildContext context) {
    final _messages = widget.messages.reversed.toList();

    final _style = widget.style ??
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
            controller: widget.scrollController,
            padding: widget.chatPadding ?? const EdgeInsets.only(bottom: 20),
            itemBuilder: (_, i) {
              if (i == 0) {
                if (widget.awaitingResponse) {
                  return widget.loadingWidget ??
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator()),
                      );
                }
                return Container();
              }

              i = i - 1;

              final builder = widget.messageBuilder;
              if (builder != null) {
                return widget.messageBuilder!(_messages[i]);
              } else {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LlmChatMessageItem(
                    showSystemMessage: widget.showSystemMessage,
                    boxDecorationBasedOnMessage:
                        widget.boxDecorationBasedOnMessage,
                    messagePadding: widget.messagePadding,
                    message: _messages[i],
                    style: _style,
                  ),
                );
              }
            },
          ),
        ),
        LLmChatTextInput(
          controller: widget.controller,
          onSubmit: (text) {
            widget.onSubmit(text);
            widget.scrollController?.jumpTo(0);
          },
        ),
      ],
    );
  }
}

class LLmChatTextInput extends StatefulWidget {
  const LLmChatTextInput({
    required this.controller,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final Function(String) onSubmit;

  @override
  State<LLmChatTextInput> createState() => _LLmChatTextInputState();
}

class _LLmChatTextInputState extends State<LLmChatTextInput> {
  void submit() {
    widget.onSubmit(widget.controller.text);
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => submit,
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
            onPressed: submit,
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
    required this.showSystemMessage,
  });

  final bool showSystemMessage;
  final LlmMessageStyle style;
  final LlmChatMessage message;
  final BoxDecoration Function(LlmChatMessage)? boxDecorationBasedOnMessage;
  final EdgeInsetsGeometry? messagePadding;

  @override
  Widget build(BuildContext context) {
    if (message.type == 'system') {
      if (!showSystemMessage) {
        return Container();
      }
    }

    final isSystem = message.type == 'system';

    BoxDecoration decoration = boxDecorationBasedOnMessage == null
        ? BoxDecoration(
            color: _getColor(), borderRadius: BorderRadius.circular(12))
        : boxDecorationBasedOnMessage!(message);

    return Opacity(
      opacity: message.type == 'system' ? .5 : 1.0,
      child: Align(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSystem)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text('System'),
                ),
              Text(
                '${message.message}',
              ),
            ],
          ),
        ),
      ),
    );
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
