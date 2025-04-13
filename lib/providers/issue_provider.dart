import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/issue.dart';

class IssueProvider extends ChangeNotifier {
  final List<Issue> _issues = [];
  final _uuid = Uuid();
  
  UnmodifiableListView<Issue> get issues => UnmodifiableListView(_issues);
  
  int get totalIssues => _issues.length;
  
  int get completedIssues => _issues.where((issue) => issue.isCompleted).length;
  
  int get pendingIssues => _issues.where((issue) => !issue.isCompleted).length;

  List<Issue> getIssuesByCategory(String category) {
    return _issues.where((issue) => issue.category == category).toList();
  }
  
  void addIssue(String title, {Priority priority = Priority.medium, String? location, String? imageUrl, String? category}) {
    final issue = Issue(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      priority: priority,
      location: location,
      imageUrl: imageUrl,
      category: category,
    );
    
    _issues.add(issue);
    notifyListeners();
  }
  
  void toggleIssueStatus(String id) {
    final index = _issues.indexWhere((issue) => issue.id == id);
    if (index != -1) {
      _issues[index] = _issues[index].copyWith(isCompleted: !_issues[index].isCompleted);
      notifyListeners();
    }
  }
  
  void removeIssue(String id) {
    _issues.removeWhere((issue) => issue.id == id);
    notifyListeners();
  }
  
  void updateIssue(String id, {String? title, bool? isCompleted, Priority? priority, String? location, String? imageUrl, String? category}) {
    final index = _issues.indexWhere((issue) => issue.id == id);
    if (index != -1) {
      _issues[index] = _issues[index].copyWith(
        title: title,
        isCompleted: isCompleted,
        priority: priority,
        location: location,
        imageUrl: imageUrl,
        category: category,
      );
      notifyListeners();
    }
  }
  
  // For demonstration purposes, add sample data
  void addSampleData() {
    if (_issues.isEmpty) {
      addIssue('Large pothole on Main Street', 
        priority: Priority.high, 
        location: '123 Main St',
        category: 'Pothole');
      addIssue('Inappropriate graffiti on park wall', 
        priority: Priority.medium,
        location: 'Central Park, West Entrance',
        category: 'Graffiti');
      addIssue('Broken street light', 
        priority: Priority.low,
        location: 'Corner of 5th and Oak',
        category: 'Street light');
    }
  }
} 