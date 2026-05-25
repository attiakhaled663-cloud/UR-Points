import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DeviceCheckPage(),
    );
  }
}

class DeviceCheckPage extends StatefulWidget {
  const DeviceCheckPage({super.key});

  @override
  State<DeviceCheckPage> createState() => _DeviceCheckPageState();
}

class _DeviceCheckPageState extends State<DeviceCheckPage> {
  bool loading = true;
  bool blocked = false;

  @override
  void initState() {
    super.initState();
    checkBan();
  }

  Future<void> checkBan() async {
    final deviceInfo = DeviceInfoPlugin();
    final android = await deviceInfo.androidInfo;
    final deviceId = android.id;

    final doc = await FirebaseFirestore.instance
        .collection('banned_devices')
        .doc(deviceId)
        .get();

    setState(() {
      blocked = doc.exists;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (blocked) {
      return const Scaffold(
        body: Center(
          child: Text('This device is blocked'),
        ),
      );
    }

    return const HomePage();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UR Points'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          )
        ],
      ),
      body: const Center(
        child: Text('هنا هيظهر استعلام النقاط'),
      ),
    );
  }
}
