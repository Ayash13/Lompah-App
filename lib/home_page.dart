import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  final Location _location = Location();
  double? _latitude;
  double? _longitude;
  late String _pesan;
  PlatformFile? pickedFile;
  PlatformFile? pickedFile2;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );

    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  UploadTask? uploadTask;
  Future uploadFile() async {
    kIsWeb == true
        ? uploadTask = FirebaseStorage.instance
            .ref('files/${pickedFile!.name}')
            .putData(pickedFile!.bytes!)
        : uploadTask = FirebaseStorage.instance
            .ref('files/${pickedFile!.name}')
            .putFile(File(pickedFile!.path!));
  }

  Future selectFile2() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'heic'],
    );

    if (result == null) return;
    setState(() {
      pickedFile2 = result.files.first;
    });
  }

  UploadTask? uploadTask2;
  Future uploadFile2() async {
    kIsWeb == true
        ? uploadTask2 = FirebaseStorage.instance
            .ref('files/${pickedFile2!.name}')
            .putData(pickedFile2!.bytes!)
        : uploadTask2 = FirebaseStorage.instance
            .ref('files/${pickedFile2!.name}')
            .putFile(File(pickedFile2!.path!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 5),
            TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Tulis pesan ',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) => _pesan = value,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectFile2();
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: pickedFile == null
                            ? Text('1. Foto sampah')
                            : kIsWeb == true
                                ? Image.memory(
                                    pickedFile2!.bytes!,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(
                                      pickedFile2!.path!,
                                    ),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      selectFile();
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: pickedFile == null
                            ? Text('2. Foto lokasi sekitar')
                            : kIsWeb == true
                                ? Image.memory(
                                    pickedFile!.bytes!,
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(
                                      pickedFile!.path!,
                                    ),
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '* Foto akan otomatis muncul jika foto keduanya sudah dipilih',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            kIsWeb == true
                ? Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Center(
                        child: Text(
                            'Tampilan google maps tidak tersedia untuk versi web')),
                  )
                : Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    //google maps with current location
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GoogleMap(
                        onTap: (latLng) {
                          setState(() {
                            _latitude = latLng.latitude;
                            _longitude = latLng.longitude;
                          });
                        },
                        mapType: MapType.satellite,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(-6.1753924, 106.8249641),
                          zoom: 15,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        buildingsEnabled: true,
                        compassEnabled: true,
                        trafficEnabled: true,
                        tiltGesturesEnabled: true,
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _location.getLocation().then((value) {
                  setState(() {
                    _latitude = value.latitude!;
                    _longitude = value.longitude!;
                  });
                });
                uploadFile();
                final snapshot = await uploadTask!.whenComplete(() {});
                final urlDownload = await snapshot.ref.getDownloadURL();
                uploadFile2();
                final snapshot2 = await uploadTask2!.whenComplete(() {});
                final urlDownload2 = await snapshot2.ref.getDownloadURL();
                if (_formKey.currentState?.validate() ?? true) {
                  _formKey.currentState?.save();
                  _firestore.collection('laporan-Sampah').add({
                    'nama':
                        FirebaseAuth.instance.currentUser?.displayName ?? "",
                    'pesan': _pesan,
                    'fotoProfile':
                        FirebaseAuth.instance.currentUser?.photoURL ?? "",
                    'lokasi':
                        _latitude.toString() + ',' + _longitude.toString(),
                    'fotoSampah': urlDownload2,
                    'fotoLokasi': urlDownload,
                    'waktu': DateTime.now().toString(),
                  });
                  Get.snackbar('Berhasil', 'Laporan berhasil dikirim',
                      backgroundColor: Color.fromARGB(129, 76, 175, 79),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP);
                }
                //reset form
                _pesan = '';
                setState(() {
                  pickedFile = null;
                  pickedFile2 = null;
                });
              },
              child: Text('Laporkan Sampah!'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                fixedSize: MaterialStateProperty.all(
                  Size(double.maxFinite, 50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
