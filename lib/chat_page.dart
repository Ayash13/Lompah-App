import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This class defines a chat page, based on a stateful widget, that contains
/// a chat screen and a form for sending messages.
///
/// To create a new ChatPage widget, the caller can use the constructor without
/// parameters or set the optional named parameter "key" with a [Key] value.
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  /// This method creates a new state associated with the ChatPage widget.
  ///
  /// It returns a new instance of _ChatPageState.
  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// This class defines the state corresponding to the ChatPage widget.
///
/// It contains a chat screen and a form for sending messages. It also retrieves
/// the current user from Firebase authentication on initialization and sets
/// the default value for the username.
class _ChatPageState extends State<ChatPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String messageText;
  late String username;

  /// This method is called when the state object is inserted into the tree.
  ///
  /// It calls [getCurrentUser], which retrieves the current user from Firebase
  /// authentication and sets the default value for the username.
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  /// This method retrieves the current user from Firebase authentication and sets
  /// the default value for the username.
  ///
  /// If there is an error retrieving the user, it prints the error message to
  /// the console.
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          username = user.displayName!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  /// This method builds the widget subtree associated with the state object.
  ///
  /// It creates a Scaffold widget with a SafeArea that contains a Column with two
  /// children: a StreamBuilder that builds a ListView from the messages collection
  /// stored in Firebase Firestore, and a Form that allows users to send new messages.
  /// The StreamBuilder listens to updates from the messages collection and rebuilds
  /// the ListView accordingly.
  ///
  /// The ListView contains a MessageBubble widget for each message in the collection.
  /// The MessageBubble widget shows the sender name, message text, and the time when
  /// the message was sent. It also visually distinguishes between messages sent by
  /// the current user and messages sent by other users.
  ///
  /// The Form contains a TextFormField where users can type their messages and a send
  /// icon button to submit the message to the messages collection in Firebase Firestore.
  /// The TextFormField is also reset to an empty value once the message is sent.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // StreamBuilder that builds a ListView from the messages collection
            StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('messages').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ),
                  );
                }
                final messages = snapshot.data!.docs.reversed;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message.get('text');
                  final messageSender = message.get('sender');
                  final currentUser = username;

                  final messageWidget = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == messageSender,
                  );
                  messageWidgets.add(messageWidget);
                }
                return Expanded(
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    children: messageWidgets,
                  ),
                );
              },
            ),

            // Form that allows users to send new messages
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  cursorColor: Colors.black,
                  onChanged: (value) => messageText = value,
                  decoration: InputDecoration(
                    hintText: 'Tulis pesan...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': username,
                          'time': Timestamp.now(),
                          'message-id':
                              _firestore.collection('messages').doc().id,
                        });

                        _formKey.currentState!.reset();
                      },
                      icon: Icon(Icons.send, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// This class defines a message bubble widget based on a stateless widget.
///
/// To create a new MessageBubble widget, the caller can set the required
/// named parameters "sender", "text", and "isMe". By default, the sender
/// is set to "Unknown Sender", the text is set to "No text", and the isMe
/// parameter is set to false.
class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  const MessageBubble({
    required this.sender,
    required this.text,
    this.isMe = false,
  });

  /// This method builds the widget subtree associated with the current stateless widget.
  ///
  /// It creates a Container widget with a child Text widget that shows the sender name,
  /// message text, and the time when the message was sent. The Container also visually
  /// distinguishes between messages sent by the current user and messages sent by other
  /// users by changing the background color and alignment of the message bubble.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          Material(
            color: isMe ? Colors.grey[200] : Colors.blueGrey[800],
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
              topRight: isMe ? Radius.circular(0) : Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
