import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sidemenu.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});
  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _notes = prefs.getStringList('notes_list') ?? []);
  }

  void _addNote(String note) async {
    if (note.isEmpty) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _notes.add(note));
    await prefs.setStringList('notes_list', _notes);
  }

  void _deleteNote(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _notes.removeAt(index));
    await prefs.setStringList('notes_list', _notes);
  }

  void _showAddNoteDialog() {
    TextEditingController noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF282828), 
        title: const Text('New Note', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: noteController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(hintText: 'Write something...', hintStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white))),
          ElevatedButton(
            onPressed: () { _addNote(noteController.text); Navigator.pop(context); },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')), // Judul ala Spotify
      drawer: const Sidemenu(),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes yet.', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: const Color(0xFF121212), 
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    tileColor: const Color(0xFF282828), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    title: Text(_notes[index], style: const TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () => _deleteNote(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        backgroundColor: const Color(0xFF1DB954), 
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}