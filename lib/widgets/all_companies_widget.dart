// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:job/search/profile_company.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllWorkersWidget extends StatefulWidget {

  final String userID;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImageUrl;

  const AllWorkersWidget({
    required this.phoneNumber,
    required this.userImageUrl,
    required this.userEmail,
    required this.userID,
    required this.userName
});

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {

  Future<void> _mailTo() async {
    var mailUrl  = 'mailTo: ${widget.userEmail}';
    print('widget.userEmail ${widget.userEmail}');

    if(await canLaunchUrlString(mailUrl))
    {
      await launchUrlString(mailUrl) ;
    }
    else
    {
      print('Error');
      throw 'Error Occurred';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white10,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.userID)));
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(widget.userImageUrl == null
            ?
                'data:image/png;base64,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'
                :
                widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'visit profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.email_outlined,
            size: 30,
            color: Colors.grey,
          ),
          onPressed: (){_mailTo();},
        ),
      ),
    );
  }
}
