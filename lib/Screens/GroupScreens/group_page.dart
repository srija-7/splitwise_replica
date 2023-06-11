import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<String> _recipients = [];

  void _addMember() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();
      String phone = _phoneController.text.trim();
      setState(() {
        _recipients.add('$name <$email>');
      });
      _sendInvitationEmail(name, email);
      _sendInvitationSMS(phone);
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
    }
  }

  void _sendInvitationEmail(String name, String email) async {
    final smtpServer = gmail('your-email@gmail.com', 'your-password');
    final message = Message()
      ..from = Address('your-email@gmail.com', 'Your Name')
      ..recipients.add(email)
      ..subject = 'Invitation to join our app'
      ..text =
          'Hello $name, please use the following link to download our app: https://your-app-url.com/invitation-code';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

  void _sendInvitationSMS(String phone) async {
    String message =
        'Hello, please use the following link to download our app: https://your-app-url.com/invitation-code';
    List<String> recipients = [phone];
    String result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) => print(onError.toString()));
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members to Group'),
        backgroundColor:  const Color.fromRGBO(76, 187, 155, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addMember,
                child: Text('Add Member'),
                style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(76, 187, 155, 1);
                        }
                        return const Color.fromRGBO(76, 187, 155, 1);
                      }),
                    ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Added Members:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
               
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _recipients.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recipients[index]),
                    );
                  },
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      String url =
                          'sms:${_phoneController.text.trim()}?body=Please use the following link to download our app: https://your-app-url.com/invitation-code';
                      launch(url);
                    },
                    icon: Icon(Icons.sms),
                    label: Text('Send SMS'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(76, 187, 155, 1);
                        }
                        return const Color.fromRGBO(76, 187, 155, 1);
                      }),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      String url =
                          'mailto:${_emailController.text.trim()}?subject=Invitation to join our app&body=Hello, please use the following link to download our app: https://your-app-url.com/invitation-code';
                      launch(url);
                    },
                    icon: Icon(Icons.email),
                    label: Text(
                      'Send Email',
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(76, 187, 155, 1);
                        }
                        return const Color.fromRGBO(76, 187, 155, 1);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
