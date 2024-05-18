import 'package:bio_lab/homepage2.dart';
import 'package:bio_lab/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';

class MyBio extends StatefulWidget {
  const MyBio({super.key});

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _supportState = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authentication"),
        backgroundColor: const Color.fromARGB(255, 84, 30, 177),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (_supportState)
          const Text("This Device is Supported BioAuthentication")
        else
          const Text("This Device is not Supported BioAuthentication"),
        const Divider(height: 100),
        ElevatedButton(
            onPressed: () {
              _getAvailableBiometics();
            },
            child: Text("Get Device")),
        const Divider(height: 100),
        ElevatedButton(
            onPressed: () {
              _authenticate();
            },
            child: const Text("Authenticated"))
      ]),
    );
  }

  void _getAvailableBiometics() async {
    List<BiometricType> availableBiometics =
        await auth.getAvailableBiometrics();
    print("List of availableBioMetrics $availableBiometics");
    //weak ใบหน้า strong fingerprint
    if (!mounted) {
      return;
    }
  }

  void _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: "Authentication Demo",
          authMessages: [
            const AndroidAuthMessages(
                signInTitle: "ยืนยันตัวตนด้วยข้อมูล BIO",
                biometricNotRecognized: "ใครเนี่ย",
                biometricSuccess: "การยืนยันถูกต้อง",
                cancelButton: "ไม่ล่ะ ขอบคุณ"),
          ],
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      if (authenticated) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(title: "Bio Accessed")),
            (route) => false);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.lockedOut) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[200], // ปรับเปลี่ยนสีพื้นหลัง
              shape: RoundedRectangleBorder(
                // กำหนดรูปทรงของ AlertDialog
                borderRadius: BorderRadius.circular(20.0), // มุมโค้ง
              ),
              title: const Text(
                "Alert",
                style: TextStyle(
                  // ปรับแต่งสไตล์ของหัวข้อ
                  color: Color.fromARGB(255, 222, 153, 4), // สีของข้อความ
                  fontWeight: FontWeight.bold, // ความหนาของฟอนต์
                ),
              ),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: [
                    Text(
                      "ผิดพลาดเกินข้อกำหนด ระบบ Lock ชั่วคราว",
                      style: TextStyle(
                        // ปรับแต่งสไตล์ของเนื้อหา
                        color: Colors.black54, // สีของข้อความ
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      // ปรับแต่งสไตล์ของปุ่ม
                      color: Colors.deepPurple, // สีของข้อความ
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print(e);
      }
    }
  }
}
