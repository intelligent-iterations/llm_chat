import 'package:equatable/equatable.dart';

class LlmChatMessage extends Equatable {
  LlmChatMessage(
      {required this.time, required this.message, required this.type});

  final int? time;
  final String? message;
  final String? type;

  LlmChatMessage.user({required this.message})
      : this.type = 'user',
        this.time = DateTime.now().millisecondsSinceEpoch;

  LlmChatMessage.assistant({required this.message})
      : this.type = 'assistant',
        this.time = DateTime.now().millisecondsSinceEpoch;

  LlmChatMessage.system({required this.message})
      : this.type = 'system',
        this.time = 0;

  @override
  List<Object?> get props => [time, message, type];

  Map<String, dynamic> toJson() {
    return {'time': time, 'message': message, 'type': type};
  }

  factory LlmChatMessage.fromJson(Map<String, dynamic> map) {
    return LlmChatMessage(
        time: map['time'], message: map['message'], type: map['type']);
  }

  LlmChatMessage copyWith({int? time, String? message, String? type}) {
    return LlmChatMessage(
        time: time ?? this.time,
        message: message ?? this.message,
        type: type ?? this.type);
  }

  static Map<String, dynamic> exampleJson() {
    return {'time': 0, 'message': "", 'type': ""};
  }

  bool match(Map map) {
    final model = toJson();
    final keys = model.keys.toList();

    for (final query in map.entries) {
      try {
        final trueValue = model[query.key];
        final exists = trueValue == query.value;
        if (exists) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static LlmChatMessage example() =>
      LlmChatMessage.fromJson(LlmChatMessage.exampleJson());
}
