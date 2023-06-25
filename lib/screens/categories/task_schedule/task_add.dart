import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliate_admin/color.dart';
import 'package:sliate_admin/screens/error_page.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String department = '';
  DateTime? _selectedDate;
  bool _itsforhnda = false;
  bool _itsforhnde = false;
  bool _itsforhndit = false;

  void addTask() async {
    if (_taskController.text.isNotEmpty) {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');

      QuerySnapshot snapshot = await tasksCollection.get();
      int taskCount = snapshot.size + 1;

      String taskId = 'Task ${taskCount.toString().padLeft(2, '0')}';

      Task newTask = Task(
        title: _taskController.text,
        description: _descriptionController.text,
        department: department,
        id: taskId,
        submissionDate: _selectedDate,
      );

      try {
        await tasksCollection.add({
          'title': newTask.title,
          'description': newTask.description,
          'id': newTask.id,
          'department': newTask.department,
          'submissionDate': newTask.submissionDate,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New Task Added Successfully')),
        );

        Navigator.pop(context, newTask);
      } catch (error) {
        ErrorHandling.navigateToErrorScreen();
      }
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg_clr,
      appBar: AppBar(
        backgroundColor: bg_clr,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'New Task',
                  style: GoogleFonts.mavenPro(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .5,
                      inherit: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _taskController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  labelText: 'Task Title',
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.all(15.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  labelText: 'Details ABout the Task',
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0),
                ),
              ),
              // RadioListTile(
              //   value: 'HNDIT',
              //   groupValue: department,
              //   onChanged: (value) {
              //     setState(() {
              //       department = value!;
              //     });
              //   },
              //   title: Text('HNDIT'),
              // ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8,
                ),
                child: Text(
                  'Choose the Department ?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: text_clr,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        department = 'hndit';
                        _itsforhndit = true;
                        _itsforhnde = false;
                        _itsforhnda = false;
                      });
                    },
                    child: Card(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _itsforhndit ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'HNDIT',
                            style: GoogleFonts.mavenPro(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                color:
                                    _itsforhndit ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        department = 'hnda';
                        _itsforhndit = false;
                        _itsforhnde = false;
                        _itsforhnda = true;
                      });
                    },
                    child: Card(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _itsforhnda ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'HNDA',
                            style: GoogleFonts.mavenPro(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: .5,
                                color:
                                    _itsforhnda ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        department = 'hnde';
                        _itsforhndit = false;
                        _itsforhnde = true;
                        _itsforhnda = false;
                      });
                    },
                    child: Card(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: _itsforhnde ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'HNDE',
                            style: GoogleFonts.mavenPro(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    _itsforhnde ? Colors.white : Colors.black,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // RadioListTile(
              //   value: 'HNDE',
              //   groupValue: department,
              //   onChanged: (value) {
              //     setState(() {
              //       department = value!;
              //     });
              //   },
              //   title: Text('HNDE'),
              // ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8,
                    ),
                    child: Text(
                      'Submission Date : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: text_clr,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: widg_clr, width: 1),
                      ),
                      backgroundColor: text_clr,
                      padding: const EdgeInsets.all(10),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text(
                      'Select Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    addTask();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: widg_clr, width: 1),
                    ),
                    backgroundColor: text_clr,
                    padding: const EdgeInsets.all(10),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  child: Text(
                    'Add New Task',
                    style: TextStyle(color: bg_clr),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String title;
  final String description;
  final String department;
  final String id;
  final DateTime? submissionDate;

  Task({
    required this.title,
    required this.description,
    required this.department,
    required this.id,
    required this.submissionDate,
  });
}
