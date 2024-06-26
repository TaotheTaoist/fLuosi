import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'new_member.dart';
import 'new_member_dialog.dart';

class HomePage extends StatefulWidget {
  final Isar isar;

  const HomePage({super.key, required this.isar});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<NewMember>> memberStream;

  @override
  void initState() {
    super.initState();
    memberStream = widget.isar.newMembers.where().watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('資料庫'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewMemberDialog(isar: widget.isar);
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<NewMember>>(
        stream: memberStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No members found.'));
          } else {
            final members = snapshot.data!;
            return ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text('Sex: ${member.isMale ? "Male" : "Female"}, '
                      'Birthday: ${member.birthday != null ? member.birthday!.toLocal().toString().split(' ')[0] : "Not set"}, '
                      'Time: ${member.time ?? "Not set"}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
