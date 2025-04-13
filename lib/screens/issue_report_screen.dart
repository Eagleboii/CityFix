import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';

class IssueReport {
  final String id;
  final String category;
  final String description;
  final String location;
  final String priority;
  final DateTime dateReported;
  bool resolved;

  IssueReport({
    required this.id,
    required this.category,
    required this.description,
    required this.location,
    required this.priority,
    required this.dateReported,
    this.resolved = false,
  });
}

class IssueReportScreen extends StatefulWidget {
  const IssueReportScreen({Key? key}) : super(key: key);

  @override
  State<IssueReportScreen> createState() => _IssueReportScreenState();
}

class _IssueReportScreenState extends State<IssueReportScreen> with TickerProviderStateMixin {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<IssueReport> _issues = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final FocusNode _focusNode = FocusNode();
  String _selectedCategory = 'Pothole';
  String _selectedPriority = 'Medium';

  final List<String> _categories = [
    'Pothole',
    'Graffiti',
    'Street light',
    'Trash',
    'Other'
  ];

  final List<String> _priorities = [
    'Low',
    'Medium',
    'High',
    'Urgent'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    // Add some sample issues for demo purposes
    _issues.add(
      IssueReport(
        id: '1',
        category: 'Pothole',
        description: 'Large pothole on Main Street',
        location: '123 Main St',
        priority: 'High',
        dateReported: DateTime.now().subtract(const Duration(days: 2)),
      ),
    );
    _issues.add(
      IssueReport(
        id: '2',
        category: 'Graffiti',
        description: 'Inappropriate graffiti on park wall',
        location: 'Central Park, west entrance',
        priority: 'Medium',
        dateReported: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addIssue() {
    if (_descriptionController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _issues.add(
        IssueReport(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          category: _selectedCategory,
          description: _descriptionController.text,
          location: _locationController.text,
          priority: _selectedPriority,
          dateReported: DateTime.now(),
        ),
      );
      _descriptionController.clear();
      _locationController.clear();
    });

    Navigator.of(context).pop(); // Close the modal
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Issue reported successfully')),
    );
  }

  void _showAddIssueModal() {
    _selectedCategory = _categories[0];
    _selectedPriority = _priorities[1]; // Default to Medium
    _descriptionController.clear();
    _locationController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Report City Issue',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Category dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Priority dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  value: _selectedPriority,
                  items: _priorities.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                
                // Description field
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the issue',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Location field
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter the address or location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addIssue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'REPORT ISSUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Get appropriate color based on priority
  Color _getPriorityColor(String priority, bool isDarkMode) {
    switch (priority) {
      case 'Low':
        return isDarkMode ? Colors.green.shade700 : Colors.green;
      case 'Medium':
        return isDarkMode ? Colors.amber.shade700 : Colors.amber;
      case 'High':
        return isDarkMode ? Colors.deepOrange.shade700 : Colors.deepOrange;
      case 'Urgent':
        return isDarkMode ? Colors.red.shade900 : Colors.red;
      default:
        return isDarkMode ? Colors.amber.shade700 : Colors.amber;
    }
  }

  void _deleteIssue(String id) {
    setState(() {
      _issues.removeWhere((issue) => issue.id == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Issue removed')),
    );
  }

  void _toggleResolved(String id) {
    setState(() {
      final issue = _issues.firstWhere((issue) => issue.id == id);
      issue.resolved = !issue.resolved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('CityFix', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                key: ValueKey<bool>(isDarkMode),
              ),
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report City Issues',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Help make our city better by reporting issues you find',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              
              Expanded(
                child: _issues.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report_problem_outlined,
                          size: 80,
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No issues reported yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to report a city issue',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.grey[600] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _issues.length,
                    itemBuilder: (context, index) {
                      final issue = _issues[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Dismissible(
                          key: Key(issue.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            _deleteIssue(issue.id);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF262626) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: _getPriorityColor(issue.priority, isDarkMode),
                                child: Icon(
                                  issue.category == 'Pothole' ? Icons.wrong_location 
                                  : issue.category == 'Graffiti' ? Icons.brush
                                  : issue.category == 'Street light' ? Icons.lightbulb
                                  : issue.category == 'Trash' ? Icons.delete
                                  : Icons.report_problem,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                issue.category,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: issue.resolved ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    issue.description,
                                    style: TextStyle(
                                      decoration: issue.resolved ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          issue.location,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                            decoration: issue.resolved ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getPriorityColor(issue.priority, isDarkMode).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      issue.priority,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getPriorityColor(issue.priority, isDarkMode),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(
                                      issue.resolved ? Icons.check_circle : Icons.check_circle_outline,
                                      color: issue.resolved 
                                          ? Colors.green 
                                          : isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                    onPressed: () => _toggleResolved(issue.id),
                                  ),
                                ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddIssueModal,
        icon: const Icon(Icons.add),
        label: const Text('REPORT ISSUE'),
      ),
    );
  }
} 