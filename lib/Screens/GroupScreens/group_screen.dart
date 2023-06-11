// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class GroupScreen extends StatefulWidget {
//   @override
//   _GroupScreenState createState() => _GroupScreenState();
// }

// class _GroupScreenState extends State<GroupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String _groupName;
//   late String _email;
//   late String _phone;
//   List<String> _members = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Group'),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Group Name',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter a group name';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _groupName = value!;
//               },
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Email',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter an email';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _email = value!;
//               },
//             ),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter a phone number';
//                 }
//                 return null;
//               },
//               onSaved: (value) {
//                 _phone = value!;
//               },
//             ),
//             ElevatedButton(
//               child: Text('Add Member'),
//               onPressed: () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                   setState(() {
//                     _members.add(_email);
//                     _members.add(_phone);
//                   });
//                   _sendInvite();
//                 }
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _members.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_members[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _sendInvite() async {
//     final currentUser = FirebaseAuth.instance.currentUser;
//     final groupRef =
//         FirebaseFirestore.instance.collection('groups').doc(_groupName);

//     await groupRef.set({
//       'members': _members,
//     });

//     final inviteUrl =
//         'https://myapp.com/invite?groupId=${groupRef.id}&email=$_email&phone=$_phone';

//     await currentUser!.sendEmailVerification();

//    // await currentUser.sendPasswordResetEmail();
//    await FirebaseAuth.instance.sendPasswordResetEmail(email:currentUser.email!);

//     // send SMS to the phone number
//   }
// }
