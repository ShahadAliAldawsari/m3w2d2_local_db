import 'package:flutter/material.dart';
import 'app_database.dart';
import 'package:drift/drift.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final db = AppDatabase();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      home: NotesHome(db: db),
    );
  }
}

class NotesHome extends StatefulWidget {
  final AppDatabase db;

  NotesHome({required this.db});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void _addNote() async {
    final title = titleController.text;
    final content = contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      await widget.db.insertNote(NotesCompanion(
        title: Value(title),
        content: Value(content),
      ));
      titleController.clear();
      contentController.clear();
      setState(() {}); // Refresh the list
    }
  }

  void _deleteNote(int id) async {
    await widget.db.deleteNoteById(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: FutureBuilder<List<Note>>(
        future: widget.db.getAllNotes(),
        builder: (context, snapshot) {
          final notes = snapshot.data ?? [];
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(labelText: 'Content'),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _addNote,
                      child: Text('Add Note'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(note.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}