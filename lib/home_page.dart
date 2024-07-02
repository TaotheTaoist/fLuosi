import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'new_member.dart';
import 'new_member_dialog.dart';
import 'baxi_page.dart';

class HomePage extends StatefulWidget {
  final Isar isar;

  const HomePage({Key? key, required this.isar}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<NewMember>> memberStream;
  int? selectedMemberId;

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

  Future<void> _deleteMember(int memberId) async {
    final member = await widget.isar.newMembers.get(memberId);
    if (member == null) {
      print('Member with ID $memberId does not exist');
      return;
    }

    try {
      await widget.isar.writeTxn(() async {
        await widget.isar.newMembers.delete(memberId);
      });
      print('Member with ID $memberId deleted successfully');
    } catch (e) {
      print('Failed to delete member with ID $memberId: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 207, 255),
      appBar: AppBar(
        title: const Text('資料庫'),
        actions: [
          if (selectedMemberId != null) // Show delete icon if a member is selected
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Member'),
                      content: const Text('Are you sure you want to delete this member?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            if (selectedMemberId != null) {
                              await _deleteMember(selectedMemberId!);
                            }
                            setState(() {
                              memberStream = widget.isar.newMembers.where().findAll().asStream();
                              selectedMemberId = null; // Clear selected member ID
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NewMemberDialog(isar: widget.isar);
                  },
                ).then((_) {
                  setState(() {
                    memberStream = widget.isar.newMembers.where().findAll().asStream();
                    selectedMemberId = null; // Clear selected member ID after adding new member
                  });
                });
              },
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<NewMember>>(
              stream: _getFilteredMembersStream(''), // Pass your search query here
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
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMemberId = member.id; // Update selected member ID
                            });
                            print('Selected Member ID: ${member.id}');
                            
                          },
                          child: Container(
                            color: selectedMemberId == member.id
                                ? Colors.blue.withOpacity(0.3) // Highlight selected item
                                : Colors.transparent,
                            child: ListTile(
                              title: Text(member.name),
                              subtitle: Text(
                                'Sex: ${member.isMale ? "Male" : "Female"}, '
                                'Birthday: ${member.birthday != null ? member.birthday!.toLocal().toString().split(' ')[0] : "Not set"}, '
                                'Time: ${member.time ?? "Not set"}',
                              ),
                            ),
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
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        '紫薇',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (selectedMemberId != null) {
                          widget.isar.newMembers.get(selectedMemberId!).then((member) {
                            if (member != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BaziPage(
                                    birthday: member.birthday,
                                    time: member.time,
                                    ),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: const Text(
                        '八字',
                        style: TextStyle(color: Colors.white),
                      ),
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
  int? selectedMemberId; // Add selectedMemberId here

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
              return GestureDetector(
                onTap: () {
                  close(context, member);
                  selectedMemberId = member.id; // Update selected member ID
                  print('Selected Member ID: ${member.id}');
                },
                child: Container(
                  color: selectedMemberId == member.id
                      ? Colors.blue.withOpacity(0.3) // Highlight selected item
                      : Colors.transparent,
                  child: ListTile(
                    title: Text(member.name),
                    subtitle: Text(
                      'Sex: ${member.isMale ? "Male" : "Female"}, '
                      'Birthday: ${member.birthday != null ? member.birthday!.toLocal().toString().split(' ')[0] : "Not set"}, '
                      'Time: ${member.time ?? "Not set"}',
                    ),
                  ),
                ),
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
