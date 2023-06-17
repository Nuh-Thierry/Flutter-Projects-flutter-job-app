import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job/search/search_companies.dart';
import 'package:job/search/search_jobs.dart';
import 'package:job/widgets/bottom_nav_bar.dart';
import 'package:job/user_state.dart';
import 'package:job/widgets/job_widget.dart';
import '../persistant/category.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? jobCategoryFilter;


  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size})
  {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'JobCategory',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
              ),
            ),
            content: Container(
              width: size.width*0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:Persistant.jobCategoryList.length,
                  itemBuilder: (ctx, index)
                  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          jobCategoryFilter= Persistant.jobCategoryList[index];
                        });
                        Navigator.canPop(context)? Navigator.pop(context) : null;
                        print(
                          'jobCategoryList[index], ${Persistant.jobCategoryList[index]}'
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              Persistant.jobCategoryList[index],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : null ;
                },
                child: const Text(
                  'close',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                  onPressed: (){
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null ;
                  },
                  child: const Text('cancel Filter',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
              ),
            ],
          );
        }
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistant persistentObject = Persistant();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavigationAppBar(indexNum: 0),
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
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AllWorkersScreen()));
                },
                icon: const Icon(Icons.search_outlined, color: Colors.black,),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('jobs')
             //  .where('jobCategory', isEqualTo: jobCategoryFilter)
             // .where('recruitments', isEqualTo: true)
             // .orderBy('createdAT', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
            {
              if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(child: CircularProgressIndicator(),);
                }
              else if(snapshot.connectionState == ConnectionState.active)
                {
                  if(snapshot.data?.docs.isNotEmpty == true)
                    {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return JobWidget(
                                jobTitle: snapshot.data?.docs[index]['jobTitle'],
                                jobDescription: snapshot.data?.docs[index]['jobDescription'],
                                jobId: snapshot.data?.docs[index]['jobId'],
                                upLoadedBy: snapshot.data?.docs[index]['uploadedBy'],
                                userImage: snapshot.data?.docs[index]['userImage'],
                                name: snapshot.data?.docs[index]['user'],
                                recruitment: snapshot.data?.docs[index]['recruitments'],
                                email: snapshot.data?.docs[index]['email'],
                                location: snapshot.data?.docs[index]['location']
                            );
                          }
                      );
                    }
                  else
                    {
                      return const Center(
                        child: Text('There are no Jobs Available'),
                      );
                    }
                }
              return const Center(
                child: Text(
                  'something went wrong',
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
