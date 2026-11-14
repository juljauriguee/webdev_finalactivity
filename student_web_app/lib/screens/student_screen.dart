import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_api.dart';
import '../widgets/student_form_dialog.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = StudentApi.getStudents();
  }

  void _reload() {
    setState(() {
      _studentsFuture = StudentApi.getStudents();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _addStudent() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const StudentFormDialog(),
    );
    if (result == null) return;
    try {
      await StudentApi.addStudent(result['name']!, result['course']!);
      if (!mounted) return;
      _reload();
      _showMessage('Student added successfully');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not add student: $e');
    }
  }

  Future<void> _editStudent(Student student) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => StudentFormDialog(student: student),
    );
    if (result == null) return;
    try {
      await StudentApi.updateStudent(
          student.id, result['name']!, result['course']!);
      if (!mounted) return;
      _reload();
      _showMessage('Student updated successfully');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not update student: $e');
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await StudentApi.deleteStudent(student.id);
      if (!mounted) return;
      _reload();
      _showMessage('Student deleted successfully');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Could not delete student: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _reload,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Student Records',
                        style: Theme.of(context).textTheme.headlineSmall),
                    FilledButton.icon(
                      onPressed: _addStudent,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Student'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue.shade400,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<Student>>(
                    future: _studentsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Failed to load students: ${snapshot.error}',
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              FilledButton(
                                onPressed: _reload,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }
                      final students = snapshot.data ?? [];
                      if (students.isEmpty) {
                        return const Center(
                            child: Text('No student records found.'));
                      }
                      return ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(student.name),
                              subtitle: Text(student.course),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () => _editStudent(student),
                                    style: TextButton.styleFrom(foregroundColor: Colors.blue.shade600),
                                    child: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton(
                                    onPressed: () => _deleteStudent(student),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red.shade400,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}