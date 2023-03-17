import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

/// This is the [TimeLine] widget, which is a StatefulWidget.
/// This widget displays a timeline of posts regarding garbage reports.
class TimeLine extends StatefulWidget {
  /// A const constructor for [TimeLine] widget.
  const TimeLine({super.key});

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('laporan-Sampah')
              .orderBy('waktu', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                final message = snapshot.data!.docs[index];
                return Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(182, 0, 0, 0),
                        ),

                        /// The [ListTile] widget is used to display a basic timeline post.
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              message['fotoProfile'],
                            ),
                          ),
                          title: Text(
                            message['nama'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(message['pesan'],
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      /// This container displays two images using [Row] and [Expanded] widgets
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 170,
                                child: Image.network(
                                  message['fotoSampah'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 170,
                                child: Image.network(
                                  message['fotoLokasi'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///This [InkWell] widget is used to show a clickable button that opens the Google Maps app
                      InkWell(
                        onTap: () async {
                          final url =
                              'https://www.google.com/maps/search/?api=1&query=${message['lokasi']}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),

                          /// This [Container] widget displays text that says "Menuju Lokasi", this text is inside a [Center] widget.
                          child: Container(
                            width: double.infinity,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(182, 0, 0, 0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Menuju Lokasi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
