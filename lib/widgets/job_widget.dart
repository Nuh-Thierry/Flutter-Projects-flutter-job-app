
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job/screens/job_details.dart';
import 'package:job/services/global_methods.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String upLoadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobId,
    required this.name,
    required this.jobDescription,
    required this.jobTitle,
    required this.location,
    required this.recruitment,
    required this.upLoadedBy,
    required this.userImage,
    required this.email,
  });


  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog()
  {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () async {
                    try
                    {
                      final uid = _uid;
                      final jobRef = FirebaseFirestore.instance.collection('jobs').doc(widget.jobId);
                      final context = ctx;
                      final jobSnapshot = await jobRef.get();
                      final jobData = jobSnapshot.data();

                      if (jobData == null) {
                        throw Exception('Job not found');
                      }
                      if(widget.upLoadedBy == _uid)
                      {
                        await jobRef.delete();
                      await Fluttertoast.showToast(
                         msg: 'Job\'s been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                      }
                      else
                      {
                        // ignore: use_build_context_synchronously
                        GlobalMethods.showErrorDialog(error: 'You can\'t delete this post', ctx: ctx);
                      }
                    }
                    catch (error)
                    {
                      GlobalMethods.showErrorDialog(error: 'This task cannot be deleted', ctx: ctx);
                    }finally{}
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.delete,
                      color: Colors.red,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(
            uploadedBy: widget.upLoadedBy,
            jobId: widget.jobId,
          )));
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Text(
             widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
