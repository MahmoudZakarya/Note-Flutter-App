import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/model/notes_model.dart';
import 'package:notes_app/services/database_helper.dart';
import '../model/photos_provider.dart';
import 'package:image_picker/image_picker.dart';



class AddEditNotePage extends ConsumerStatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  ConsumerState<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends ConsumerState<AddEditNotePage> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      if(widget.note?.photos != null) {
        ref.read(photosProvider.notifier).setPhotos(widget.note!.photos ?? []);
      }



    }
  }


  Future<void> _pickPhotos() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      final newPhotos = pickedFiles.map((file) => file.path).toList();
      ref.read(photosProvider.notifier).addPhotos(newPhotos);
    }
  }

  Future<void> _removePhoto(int index) async {
    ref.read(photosProvider.notifier).removePhoto(index);
  }

  @override
  Widget build(BuildContext context) {
    final photos = ref.watch(photosProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(widget.note != null ? "Edit Note" : "Add Note ", style:
          TextStyle(color: Colors.white),),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter a Title";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12,),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: "Write something!",
                    hintStyle: TextStyle(color: Colors.white60),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),

                  ),
                  maxLines: 12,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "You have to write something or just cancel";
                    }
                    return null;
                  },
                ),



                //   PHOTOS GRID PLACE

                if (photos.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: photos.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(photos[index]),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                const SizedBox(height: 16),

                // Add Photos Button
                InkWell(
                  onTap: _pickPhotos,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Add Photos",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),


                // PHOTOS END

                // SAVE BUTTON
                InkWell(onTap: () {
                  _saveNote();
                  Navigator.pop(context);
                },
                  child: Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(12),

                    ),

                    child: Center(
                      child: Text("Save Note"),
                    ),

                  ),
                ),
                SizedBox(height: 8,),
                InkWell(onTap: () {
                  Navigator.pop(context);
                },
                  child: Container(
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),

                    ),

                    child: Center(
                      child: Text("Cancel",
                      style: TextStyle(color: Colors.white),),
                    ),

                  ),
                )


              ],
            ),
          )),
    );
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
          id: widget.note?.id ?? 0,
          title: _titleController.text,
          content:  _contentController.text,
          photos: widget.note?.photos,
          date: DateTime.now().toString()
      );


      if(widget.note == null){
        await _databaseHelper.insertNote(note);
        await ref.read(notesProvider.notifier).addOrUpdateNote(note);
      } else {
        await _databaseHelper.updateNote(note);
        await ref.read(notesProvider.notifier).addOrUpdateNote(note);

      }

    }
  }


}

