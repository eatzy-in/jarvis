import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Detail"), actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Center(
                  child: Text(
                "Save",
                style: TextStyle(fontSize: 18),
              )),
            ))
      ]),
      body: SingleChildScrollView(
        child: getMyWidget(),
      ),
    );
  }

  getMyWidget() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        paymentDetailSetup(),
        SizedBox(
          height: 10,
        ),
        menuUploadSetup(),
        SizedBox(
          height: 10,
        ),
        contactDetailSetup(),
        SizedBox(
          height: 10,
        ),
        uploadGallerySetup(),
      ],
    );
  }

  paymentDetailSetup() {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Payment Details"),
            ),
            Divider(),
            Row(
              children: <Widget>[
                const Divider(),
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        hintText: 'Enter UPI ID',
                        suffixIcon: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.credit_card),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  menuUploadSetup() {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("Upload Your Menu Card"),
            ),
            Divider(),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: const Text('Upload Menu'),
                  onPressed: () async {
                    var picked = await FilePicker.platform.pickFiles();

                    if (picked != null) {
                      print(picked.files.first.name);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  contactDetailSetup() {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("Enter Contact Details"),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        hintText: 'Enter Contact Number',
                        suffixIcon: IconButton(
                          onPressed: () async {},
                          icon: const Icon(Icons.credit_card),
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  uploadGallerySetup() {
    return Card(
      elevation: 10,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            const ListTile(
              title: Text("Upload Your Gallery"),
            ),
            Divider(),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: const Text('Upload Gallery'),
                  onPressed: () async {
                    var picked = await FilePicker.platform.pickFiles();

                    if (picked != null) {
                      print(picked.files.first.name);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
