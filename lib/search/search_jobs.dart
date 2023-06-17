import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job/widgets/all_companies_widget.dart';

import '../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search Query';

  Widget _buildSearchField()
  {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'search for companies...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions()
  {
    return <Widget>[
      IconButton(
        onPressed: (){
          _clearSearchQuery();
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  void _clearSearchQuery()
  {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery)
  {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade300, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationAppBar(indexNum: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white54, Colors.deepPurpleAccent.shade200],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
          .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.data?.docs.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return AllWorkersWidget
                        (phoneNumber: snapshot.data?.docs[index]['phoneNumber'],
                          userImageUrl: snapshot.data?.docs[index]['userImage'],
                          userEmail: snapshot.data?.docs[index]['email'],
                          userID: snapshot.data?.docs[index]['id'],
                          userName: snapshot.data?.docs[index]['name']
                      );
                    }
                );
              }
              else
              {
                return const Center(
                  child: Text('No current Available user'),
                );
              }
            }
            return const Center(
              child: Text('Something went Wrong',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              ),
            );
          }
        ),
      ),
    );
  }
}
