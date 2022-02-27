import 'dart:convert';
import 'dart:developer';

//import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SCanQr extends StatefulWidget {
  const SCanQr({Key? key}) : super(key: key);

  @override
  _SCanQrState createState() => _SCanQrState();
}

class _SCanQrState extends State<SCanQr> {
  String result = '';

  Future<String> _scanQR() async {
    ScanResult qrResult = ScanResult();
    try {
      qrResult = await BarcodeScanner.scan();
      // ignore: nullable_type_in_catch_clause
    } catch (ex) {
      log(ex.toString());
    }

    return qrResult.rawContent.toString();
  }

  String ContractHitUrl = "https://qrious-backend.herokuapp.com/";

  Future<List> _fetchProduct(String id) async {
    List product = [];
    http.Response res = await http.get(Uri.parse("$ContractHitUrl$id"));
    print(res.body);
    if (res.body.contains("<!DOCTYPE html>")) {
    } else {
      product = jsonDecode(res.body);
    }
    return product;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scanQR();
  }

  List product = [];

  productDetails(String prodname, String imgUrl, String description,
      String brandName, String mrp) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.network(imgUrl, height: 200, width: 200)),
          const SizedBox(height: 10),
          Center(
            child: Text(brandName,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                )),
          ),
          const SizedBox(height: 10),
          Text(prodname),
          const SizedBox(height: 10),
          Text(description),
          const SizedBox(height: 10),
          Text("M.R.P :- $mrp"),
          const SizedBox(height: 30),
          Text(
            "Yes this one is a genuine product from $brandName",
            style: TextStyle(color: Colors.green, fontSize: 22),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QRious",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
      ),
      bottomNavigationBar: Container(
        height: 100,
        color: Colors.transparent,
        child: Center(
          child: InkWell(
            onTap: () async {
              String result = await _scanQR();
              print(result);
              product = await _fetchProduct(result);
              if (product.isEmpty) {
                showAlertDialog(context);
              }
              setState(() {});
            },
            child: Container(
              height: 50,
              width: 140,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.blue),
              child: Center(
                  child: Text("Scan Product Qr",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ))),
            ),
          ),
        ),
      ),
      body: Container(
        child: product.isEmpty
            ? Center(
                child: Text("Scan Product's Qr \n to know it's Authenticity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    )),
              )
            : productDetails(
                product[1].toString(),
                product[2].toString(),
                product[3].toString(),
                product[4].toString(),
                product[5].toString()),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(
        "Either This product is a Counterfiet or May be the brand is not Affiliated to us",
        style: TextStyle(color: Colors.red, fontSize: 14),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
