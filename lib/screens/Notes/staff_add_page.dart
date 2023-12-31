import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliate_admin/color.dart';
class staff_add extends StatefulWidget {
  @override
  _staff_addState createState() => _staff_addState();
}

class _staff_addState extends State<staff_add> {
final TextEditingController _staffNameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  late FirebaseFirestore
      _firestore; 
  bool _isImageSelected = false;
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
     _initializeFirestore(); 
  }

  void _initializeFirestore() {
    _firestore = FirebaseFirestore.instance;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _isImageSelected = true;
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImageToFirebase() async {
    if (_image == null) {
      return;
    }

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('staffs/$fileName');
      UploadTask uploadTask = ref.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      saveDataToFirestore(imageUrl);
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  Future<void> saveDataToFirestore(String imageUrl) async {
    String staffName = _staffNameController.text.trim();
    String position = _positionController.text.trim();
    String field = _fieldController.text.trim();

    try {
      CollectionReference staffsCollection =
          FirebaseFirestore.instance.collection('staffs');

      QuerySnapshot snapshot = await staffsCollection.get();
      int staffCount = snapshot.size + 1;

      String staffId = 'S${staffCount.toString().padLeft(4, '0')}';

      await staffsCollection.add({
        'staff_id': staffId,
        'staff_name': staffName,
        'position': position,
        'image_url': imageUrl,
        'field': field,
      });

      setState(() {
        _staffNameController.clear();
        _positionController.clear();
        _fieldController.clear();
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved to Firestore successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data to Firestore: $e')),
      );
    }
  }

  void deleteStaff(String staffId) {
    _firestore.collection('staffs').doc(staffId).delete().catchError((error) {
      // Handle the error if needed
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg_clr,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Staff',
              style: GoogleFonts.mavenPro(
                textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: _staffNameController,
              decoration: const InputDecoration(labelText: 'Staff Name'),
            ),
            TextField(
              controller: _positionController,
              decoration: const InputDecoration(labelText: 'Position'),
            ),
            ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isImageSelected ? Colors.green : null,
              ),
              child: Text(
                _isImageSelected ? 'Image Uploaded' : 'Pick an Image',
                style: TextStyle(
                  color: _isImageSelected ? Colors.black : null,
                ),
              ),
            ),
            TextField(
              controller: _fieldController,
              decoration: const InputDecoration(labelText: 'Field'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadImageToFirebase,
              child: const Text('Add Data'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Added Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('staffs').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      String staffName =
                          documents[index].get('staff_name') ?? '';
                      String position = documents[index].get('position') ?? '';
                      String imageUrl = documents[index].get('image_url') ?? '';
                      String field = documents[index].get('field') ?? '';
                      String staffId = documents[index].id;

                      return ListTile(
                        title: Text(staffName),
                        leading: Image.network('$imageUrl'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Position: $position'),
                            Text('Field: $field'),
                            Text('Staff ID: $staffId'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteStaff(staffId),
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
    );
  }
}
