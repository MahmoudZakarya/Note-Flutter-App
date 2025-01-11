import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:shadcn_ui/shadcn_ui.dart'; // Ensure this package is added to your dependencies

import '../model/notes_model.dart';
import 'add_edit_page.dart';

class ViewNotePage extends ConsumerWidget {
  final Note note;

  const ViewNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          note.title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        actions: [
          // Edit Button
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Edit Note',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNotePage(note: note),
                ),
              );
              Navigator.pop(context); // Return to previous page after editing
            },
          ),
          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            tooltip: 'Delete Note',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Note'),
                  content: const Text('Are you sure you want to delete this note?'),
                  actions: [
                    ShadButton.ghost(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),

                    ),
                    ShadButton.destructive(
                      child: Text('Delete'),
                      onPressed: () async{
                        await ref.read(notesProvider.notifier).deleteNote(note.id ?? 0);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Return to previous page
                      },

                    ),
                  ],
                ),
              );
            },
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: 'Share Note',
            onPressed: () {
              final content = '${note.title}\n\n${note.content}';
              Share.share(content);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos Grid
            if (note.photos != null && note.photos!.isNotEmpty)
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 3, // Max grid column count: 3
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: note.photos!.length,
                itemBuilder: (context, index) {
                  final photoPath = note.photos![index];
                  return ShadCard(
                    padding: const EdgeInsets.all(4),
                    radius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(photoPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),

            // Note Content
            Text(
              note.content,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 16),

            // Note Date
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                note.date,
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons (Optional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ShadButton.outline(
                  icon: ShadImage(LucideIcons.pencil),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEditNotePage(note: note)),
                    );
                    Navigator.pop(context); // Return to the previous page after editing
                  },

                ),
                ShadButton.outline(

                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Note'),
                        content: const Text('Are you sure you want to delete this note?'),
                        actions: [
                          ShadButton.ghost(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ShadButton.destructive(
                            child: Text('Delete'),
                            onPressed: () {
                              // TODO: Call your delete logic here
                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Return to previous page
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: ShadImage(LucideIcons.trash),

                  child: Text('Delete'),
                ),
                ShadButton(
                  onPressed: () {
                    final content = '${note.title}\n\n${note.content}';
                    Share.share(content);
                  },
                  icon: const Icon(Icons.share),
                  child: Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
