import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_constants.dart';
import 'ai_coach_service.dart';

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiCoachService _coachService = AiCoachService();

  final List<AiChatMessage> _messages = [
    AiChatMessage(
      sender: 'coach',
      message: 'Hello! I am your MANI FIT AI Health & Fitness Coach. I can help answer questions regarding your meal plan, hydration goals, recovery strategies, and workout form. How can I assist your fitness journey today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isDisclaimerVisible: true,
    ),
  ];

  bool _isTyping = false;

  final List<String> _quickSuggestions = [
    'How do I hit my daily protein target?',
    'What should I eat before morning workouts?',
    'How can I improve my sleep recovery?',
    'Is a 500 kcal deficit safe for fat loss?',
  ];

  void _sendMessage([String? preset]) async {
    final text = preset ?? _textController.text.trim();
    if (text.isEmpty) return;

    if (preset == null) {
      _textController.clear();
    }

    setState(() {
      _messages.add(AiChatMessage(
        sender: 'user',
        message: text,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _scrollToBottom();

    // Query AI Coach service with user context
    final response = await _coachService.queryCoach(
      userQuery: text,
      userName: 'Athlete',
      age: 26,
      goal: 'Weight Loss & Muscle Tone',
      dailyCalories: 1950.0,
      dietaryPattern: 'Vegetarian',
    );

    setState(() {
      _isTyping = false;
      _messages.add(AiChatMessage(
        sender: 'coach',
        message: response,
        timestamp: DateTime.now(),
        isDisclaimerVisible: true,
      ));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('MANI FIT AI Coach', style: AppTypography.headingLarge(color: Colors.white)),
            Text(
              'Evidence-Based Fitness Advisor',
              style: AppTypography.bodySmall(color: AppColors.roseChampagne).copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Safety Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.lightPink,
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, size: 18, color: AppColors.primaryBurgundy),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI advice is educational only. It does not replace medical consultation.',
                    style: AppTypography.bodySmall(color: AppColors.deepBurgundy).copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg.sender == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primaryBurgundy : Colors.white,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                      ),
                      border: isUser ? null : Border.all(color: AppColors.borderLight),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.charcoal.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.message,
                          style: isUser
                              ? AppTypography.bodyLarge(color: Colors.white)
                              : AppTypography.bodyLarge(color: AppColors.charcoal),
                        ),
                        if (msg.isDisclaimerVisible) ...[
                          const SizedBox(height: 8),
                          Text(
                            '⚠️ Not medical advice',
                            style: AppTypography.bodySmall(color: AppColors.slateGrey).copyWith(fontSize: 9),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isTyping) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBurgundy),
                  ),
                  const SizedBox(width: 8),
                  Text('Coach is generating insights...', style: AppTypography.bodySmall()),
                ],
              ),
            ),
          ],

          // Quick Suggestion Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _quickSuggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _quickSuggestions[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(suggestion, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.borderLight),
                    onPressed: () => _sendMessage(suggestion),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Ask fitness or nutrition questions...',
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.send),
                  style: IconButton.styleFrom(backgroundColor: AppColors.primaryBurgundy),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
