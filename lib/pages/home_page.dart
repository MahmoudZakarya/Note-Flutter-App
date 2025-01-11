import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_app/pages/view_page.dart';

import '../model/notes_model.dart';
import 'add_edit_page.dart';




String formatDate(String date){
  final DateTime cd = DateTime.parse(date);
  final DateTime now = DateTime.now();

  if(cd.year == now.year && cd.month == now.month && cd.day == now.day){
    return 'Today, ${cd.hour.toString().padLeft(2 , "0")}:${cd.minute.toString().padLeft(0, '0')}';
  }

  return '${cd.day}/${cd.month}/${cd.year}, ${cd.hour.toString().padLeft(2 , "0")}:${cd.minute.toString().padLeft(0, '0')}';

}
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context,  WidgetRef ref) {

    final notes = ref.watch(notesProvider);

    ref.read(notesProvider.notifier).loadNotes();


    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text("Notes", style: TextStyle(
            color: Colors.white
        ), ),
      ),

      body:notes.isEmpty?

      Center(child: Text("Write your first note !!", style: TextStyle(fontSize: 18),)):

      GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16
          ),
          itemCount: notes.length,
          itemBuilder: (context, index){


            return GestureDetector(
              onTap: () async{
                 await Navigator.push(context, MaterialPageRoute(builder:
                 (context)=> ViewNotePage(note: notes[index])));


              },

              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),

                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes[index].title,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8,),

                      Text(
                        notes[index].content,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white54
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      Text(
                        formatDate(notes[index].date),
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  )
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEditNotePage(),));
        ref.read(notesProvider.notifier).loadNotes();

      },
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
      );





  }
}



