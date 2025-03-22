import 'package:flutter/material.dart';
import 'package:flutter_application_1/locator.dart';
import 'package:flutter_application_1/model/messages.dart';
import 'package:flutter_application_1/model/question.dart';
import 'package:flutter_application_1/model/response.dart';
import 'package:flutter_application_1/services/chatbot_service.dart';

class Chatbot extends StatefulWidget {
  final String name;

  const Chatbot({
    super.key,
    required this.name,
  });

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  var questionIndex = 0;

  final List<Question> _questions = [];
  final List<Messages> _chatMessages = [];
  final List<Question> _responseQuestions = [];
  final List<Options> _responseOptions = [];
  final List<String> _responsesMessages = [];
  final TextEditingController _controller = TextEditingController();
  ChatbotService chatbotService = locator<ChatbotService>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final initMessage = Messages(
      id: "init-question",
      message: "Hola ${widget.name}, Bienvenido/a al asistente virtual de PetsMarket",
      isBot: true,
    );

    _chatMessages.add(initMessage);
    _initConversation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      debugPrint('Scrolling to bottom');
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> _initConversation() async {
    final questions = await chatbotService.getQuestion();
    _questions.addAll(questions);
    final question = questions[questionIndex];
    setState(() {
      _chatMessages.add(
        Messages(
          id: question.id.toString(),
          message: question.text,
          isBot: true,
          options: question.options,
        ),
      );
    });
  }

  Future<void> _onOptionPressed(Options option, Messages message) async {
    try {
      setState(() {
        _chatMessages.add(
          Messages(id: 'user-${message.id}', message: option.text, isBot: false),
        );
        _responsesMessages.add(message.id);
        if (message.id != 'reset') {
          _responseQuestions.add(_questions[questionIndex]);
        }
        _responseOptions.add(option);
        _controller.clear();
      });

      questionIndex += 1;
      if (message.id == 'reset') {
        if (option.estadoValidacion == 1) { // Si selecciona "Sí"
          setState(() {
            _chatMessages.clear();
            _responseQuestions.clear();
            _responseOptions.clear();
            _responsesMessages.clear();
            _questions.clear();
            questionIndex = 0;
          });
          await _initConversation();
        } else { // Si selecciona "No"
          setState(() {
            _chatMessages.add(
              Messages(
                id: 'farewell',
                message: 'Gracias por usar nuestra Pets IA. Que tenga buen día. Si desea comunicarse con la veterinaria, llame al número (04) 240-0225.',
                isBot: true,
              ),
            );
          });
        }
        return;
      } else {
        if (questionIndex < _questions.length) {
          final question = _questions[questionIndex];
          setState(() {
            _chatMessages.add(
              Messages(
                id: question.id.toString(),
                message: question.text,
                isBot: true,
                options: question.options,
              ),
            );
          });
        } else {
          _predict();
        }
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _scrollToBottom();
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _predict() async {
    final prediction = await _sendResponses();
    final resultMessage = Messages(
      id: 'prediction',
      message: 'El resultado es: ${prediction.resultado}',
      isBot: true,
    );
    final confidenceMessage = Messages(
      id: 'confidence',
      message: 'Con una probabilidad del: ${prediction.confianza} que tenga esa enfermedad',
      isBot: true,
    );
    final treatments = Messages(
      id: 'treatments',
      message: 'Tratamientos: \n * ${prediction.tratamientos.map((t) => t.tratamiento).join('\n *')}',
      isBot: true,
    );
    final adviceMessage = Messages(
      id: 'advice',
      message: 'Recuerde que esto es un posible diagnóstico, para confirmarlo debe acercarse a la veterinaria con urgencia. Gracias por usar PetsIA.',
      isBot: true,
    );
    final resetMessage = Messages(
      id: 'reset',
      message: '¿Desea realizar otra consulta?',
      isBot: true,
      options: const [
        Options(id: 1, text: 'Sí', estado: 1, estadoValidacion: 1),
        Options(id: 2, text: 'No', estado: 1, estadoValidacion: 0),
      ],
    );

    setState(() {
      _chatMessages.add(resultMessage);
      _chatMessages.add(confidenceMessage);
      _chatMessages.add(treatments);
      _chatMessages.add(adviceMessage);
      _chatMessages.add(resetMessage);
    });
  }

  Future<Prediction> _sendResponses() async {
    final answersMap = <String, int>{};
    _responseQuestions.asMap().forEach((index, q) {
      final symptom = Symptom(id: q.symptom.id, nombre: q.symptom.nombre, estado: 1);
      final answer = Answer(symptom: symptom, value: _responseOptions[index].estadoValidacion);
      final currentValue = answersMap[symptom.nombre] ?? 0;
      answersMap[symptom.nombre] = answer.value | currentValue;
    });

    return chatbotService.predict(answersMap);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco como en la pantalla de registro
      appBar: AppBar(
        title: const Text(
          'Asistente Virtual',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Texto en negro
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Fondo blanco para la AppBar
        elevation: 1, // Sombra ligera para la AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                final message = _chatMessages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MessageBubble(
                      message: message.message,
                      isUserMessage: !message.isBot,
                    ),
                    if (message.options.isNotEmpty)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        alignment: WrapAlignment.center,
                        children: message.options.map((option) {
                          final isButtonDisabled = _responsesMessages.any((msgId) => msgId == message.id);
                          return ElevatedButton(
                            onPressed: isButtonDisabled ? null : () async => await _onOptionPressed(option, message),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF1976D2)), // Borde azul como en la pantalla de registro
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            ),
                            child: Text(
                              option.text,
                              style: const TextStyle(color: Color(0xFF1976D2)), // Texto azul
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? const Color(0xFF1976D2) : Colors.white, // Azul para el usuario, blanco para el bot
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUserMessage ? const Radius.circular(12) : Radius.zero,
            bottomRight: isUserMessage ? Radius.zero : const Radius.circular(12),
          ),
          border: Border.all(
            color: isUserMessage ? const Color(0xFF1976D2) : Colors.grey.shade300, // Borde azul para el usuario, gris claro para el bot
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUserMessage ? Colors.white : Colors.black, // Blanco para el usuario, negro para el bot
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}