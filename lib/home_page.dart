import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'new_member.dart';
import 'new_member_dialog.dart';

class HomePage extends StatefulWidget {
  final Isar isar;

  const HomePage({Key? key, required this.isar}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<NewMember>> memberStream;
  bool isPressed = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    memberStream = widget.isar.newMembers.where().findAll().asStream();
  }

  Stream<List<NewMember>> _getFilteredMembersStream(String query) {
    if (query.isEmpty) {
      return widget.isar.newMembers.where().findAll().asStream();
    } else {
      return widget.isar.newMembers
          .where()
          .filter()
          .nameEqualTo(query)
          .findAll()
          .asStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 207, 255),
      appBar: AppBar(
        title: const Text('資料庫'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isPressed = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  isPressed = false;
                });
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NewMemberDialog(isar: widget.isar);
                  },
                ).then((_) {
                  // Refresh the stream after adding a new member
                  setState(() {
                    memberStream =
                        widget.isar.newMembers.where().findAll().asStream();
                  });
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: isPressed ? 40 : 50,
                height: isPressed ? 40 : 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 172, 172, 172),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 34, 74, 255),
                  size: 24,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<NewMember>>(
              stream: _getFilteredMembersStream(searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No members found.'));
                } else {
                  final members = snapshot.data!;
                  return Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListView.separated(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        return ListTile(
                          title: Text(member.name),
                          subtitle: Text(
                            'Sex: ${member.isMale ? "Male" : "Female"}, '
                            'Birthday: ${member.birthday != null ? member.birthday!.toLocal().toString().split(' ')[0] : "Not set"}, '
                            'Time: ${member.time ?? "Not set"}',
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          BottomAppBar(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: MemberSearchDelegate(widget.isar),
                        );
                      },
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: const Icon(Icons.person),
                      onPressed: () {},
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberSearchDelegate extends SearchDelegate {
  final Isar isar;

  MemberSearchDelegate(this.isar);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = isar.newMembers
        .where()
        .filter()
        .nameContains(query)
        .findAll()
        .asStream();

    return StreamBuilder<List<NewMember>>(
      stream: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No members found.'));
        } else {
          final members = snapshot.data!;
          return ListView.separated(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                title: Text(member.name),
                subtitle: Text(
                  'Sex: ${member.isMale ? "Male" : "Female"}, '
                  'Birthday: ${member.birthday != null ? member.birthday!.toLocal().toString().split(' ')[0] : "Not set"}, '
                  'Time: ${member.time ?? "Not set"}',
                ),
                onTap: () {
                  // Do something when a member is tapped
                  close(context, member);
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
            ),
          );
        }
      },
    );
  }
}
