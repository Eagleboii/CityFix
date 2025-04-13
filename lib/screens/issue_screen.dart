import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../models/issue.dart';
import '../providers/theme_provider.dart';
import '../providers/issue_provider.dart';
import '../utils/app_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class IssueScreen extends StatefulWidget {
  const IssueScreen({Key? key}) : super(key: key);

  @override
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  String _selectedCategory = 'Pothole';
  Priority _selectedPriority = Priority.medium;
  String _location = '';

  final List<String> _categories = ['Pothole', 'Graffiti', 'Street light', 'Trash', 'Other'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    
    // Load sample data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<IssueProvider>(context, listen: false).addSampleData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final issueProvider = Provider.of<IssueProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('app_name')),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              key: ValueKey<bool>(themeProvider.isDarkMode),
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                localizations.translate('issues'),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Help improve your community by reporting issues',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                '${localizations.translate('issues').toUpperCase()} (${issueProvider.totalIssues})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: issueProvider.issues.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.report_problem_outlined,
                              size: 80,
                              color: isDark ? Colors.grey[700] : Colors.grey[300],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No issues reported yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: issueProvider.issues.length,
                        itemBuilder: (context, index) {
                          final issue = issueProvider.issues[index];
                          return Dismissible(
                            key: Key(issue.id),
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.red.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              issueProvider.removeIssue(issue.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Issue deleted'),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height - 150,
                                    left: 10,
                                    right: 10,
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: issue.isCompleted
                                    ? (isDark ? Colors.grey[800] : Colors.grey[200])
                                    : _getPriorityColor(issue.priority, isDark),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                title: Text(
                                  issue.title,
                                  style: TextStyle(
                                    decoration: issue.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: issue.isCompleted
                                        ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                        : (isDark ? Colors.white : Colors.black),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (issue.category != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          issue.category!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: issue.isCompleted
                                                ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                                : (isDark ? Colors.grey[400] : Colors.grey[700]),
                                          ),
                                        ),
                                      ),
                                    if (issue.location != null && issue.location!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: issue.isCompleted
                                                  ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                issue.location!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: issue.isCompleted
                                                      ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                                      : (isDark ? Colors.grey[400] : Colors.grey[700]),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        DateFormat('MMM d, yyyy').format(issue.createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: issue.isCompleted
                                              ? (isDark ? Colors.grey[500] : Colors.grey[600])
                                              : (isDark ? Colors.grey[400] : Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      issueProvider.toggleIssueStatus(issue.id);
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: issue.isCompleted
                                          ? Colors.green
                                          : (isDark ? Colors.grey[700] : Colors.white),
                                      shape: BoxShape.circle,
                                      border: issue.isCompleted
                                          ? null
                                          : Border.all(
                                              color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                                              width: 2,
                                            ),
                                    ),
                                    child: issue.isCompleted
                                        ? const Icon(Icons.check, size: 15, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showReportIssueDialog,
        backgroundColor: const Color(0xFF8C61FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getPriorityColor(Priority priority, bool isDark) {
    switch (priority) {
      case Priority.high:
        return isDark ? Colors.red.shade800 : Colors.red.shade100;
      case Priority.medium:
        return isDark ? Colors.orange.shade800 : Colors.orange.shade100;
      case Priority.low:
        return isDark ? Colors.green.shade800 : Colors.green.shade100;
      default:
        return isDark ? Colors.grey.shade800 : Colors.grey.shade100;
    }
  }

  void _showReportIssueDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    final localizations = AppLocalizations.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizations.translate('report_issue'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _textController,
                    focusNode: _textFocusNode,
                    autofocus: true,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: localizations.translate('description'),
                      hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color(0xFF8C61FF), width: 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _location = value;
                      });
                    },
                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      hintText: localizations.translate('location'),
                      hintStyle: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: const Color(0xFF8C61FF), width: 1),
                      ),
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "${localizations.translate('category')}:",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isDense: true,
                            dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                            items: _categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        "${localizations.translate('priority')}:",
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _priorityOption(localizations.translate('low'), Priority.low, setState, isDark),
                      _priorityOption(localizations.translate('medium'), Priority.medium, setState, isDark),
                      _priorityOption(localizations.translate('high'), Priority.high, setState, isDark),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        Provider.of<IssueProvider>(context, listen: false).addIssue(
                          title: _textController.text,
                          category: _selectedCategory,
                          priority: _selectedPriority,
                          location: _location,
                        );
                        _textController.clear();
                        _location = '';
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a description'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C61FF),
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      localizations.translate('submit'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _textController.clear();
      _location = '';
      setState(() {
        _selectedCategory = 'Pothole';
        _selectedPriority = Priority.medium;
      });
    });
  }

  Widget _priorityOption(String label, Priority priority, StateSetter setState, bool isDark) {
    final bool isSelected = _selectedPriority == priority;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? _getPriorityColor(priority, isDark)
              : isDark ? Colors.grey.shade900 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
              ? null 
              : Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? Colors.white 
                : isDark ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 