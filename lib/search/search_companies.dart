import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job/screens/jobs-screen.dart';
import 'package:job/widgets/bottom_nav_bar.dart';
import 'package:job/widgets/job_widget.dart';

class AllWorkersScreen extends StatefulWidget {


  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Search Query';

  Widget _buildSearchField()
  {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'search for jobs...',
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
       // bottomNavigationBar: BottomNavigationAppBar(indexNum: 1,),
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
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobsScreen()));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String , dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
              .where('recruitments', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
            else if (snapshot.connectionState == ConnectionState.active)
            {
              if(snapshot.data?.docs.isNotEmpty == true)
              {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return JobWidget(
                          jobId: snapshot.data?.docs[index]['jobId'],
                          name: snapshot.data?.docs[index]['user'],
                          jobDescription: snapshot.data?.docs[index]['jobDescription'],
                          jobTitle: snapshot.data?.docs[index]['jobTitle'],
                          location: snapshot.data?.docs[index]['location'],
                          recruitment: snapshot.data?.docs[index]['recruitments'],
                          upLoadedBy: snapshot.data?.docs[index]['uploadedBy'],
                          userImage: snapshot.data?.docs[index]['userImage'],
                          email: snapshot.data?.docs[index]['email']
                      );
                    }
                );
              }
              else
              {
                return const Center(
                  child: Text('There are no jobs available for you search'),
                );
              }
            }
            return const Center(
              child: Text(
              'Something went wrong',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
