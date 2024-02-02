import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Numerology extends StatefulWidget {
  const Numerology({Key? key}) : super(key: key);

  @override
  _NumerologyState createState() => _NumerologyState();
}

class _NumerologyState extends State<Numerology> {
  String dayDropdownValue = 'Ngày';
  String monthDropdownValue = 'Tháng';
  String yearDropdownValue = 'Năm';
  String info = '';
  String fullName = ''; // Tên đã nhập
  String result = '';

  Future<void> fetchData() async {
    // Ensure that all required fields are filled before making the API call
    if (fullName.isEmpty ||
        dayDropdownValue == 'Ngày' ||
        monthDropdownValue == 'Tháng' ||
        yearDropdownValue == 'Năm') {
      // Handle the case when any of the required fields is not filled
      return;
    }

    // Convert dropdown values to integers
    int day = int.tryParse(dayDropdownValue) ?? 0;
    int month = int.tryParse(monthDropdownValue) ?? 0;
    int year = int.tryParse(yearDropdownValue) ?? 0;

    // Prepare the data for the API request
    Map<String, dynamic> requestData = {
      'name': fullName,
      'date': day,
      'month': month,
      'year': year,
    };

    // Convert the request data to JSON
    String jsonData = jsonEncode(requestData);

    try {
      // Make the API request
      http.Response response = await http.post(
        Uri.parse('https://dream-abb4snyjiq-df.a.run.app/v1/get-numerology'),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse and update the result based on the API response
        Map<String, dynamic> apiResponse = jsonDecode(response.body);
        setState(() {
          result = apiResponse['data']['number'].toString();
          info = apiResponse['data']['info'];
        });
      } else {
        // Handle the case when the API request was not successful
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } catch (error) {
      // Handle any exceptions that may occur during the API request
      setState(() {
        result = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tra cứu thần số học'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Vui lòng nhập thông tin để chúng tôi kiểm tra giúp bạn',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  fullName = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Họ và Tên',
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: dayDropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        dayDropdownValue = newValue!;
                      });
                    },
                    items: [
                      'Ngày',
                      ...List.generate(31, (index) => (index + 1).toString())
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: monthDropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        monthDropdownValue = newValue!;
                      });
                    },
                    items: [
                      'Tháng',
                      ...List.generate(12, (index) => (index + 1).toString())
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: yearDropdownValue,
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setState(() {
                        yearDropdownValue = newValue!;
                      });
                    },
                    items: [
                      'Năm',
                      ...List.generate(
                        100,
                        (index) => (1950 + index).toString(),
                      )
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    isExpanded: true,
                    dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
            if (result.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 225, 225),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card for personal information
                    Card(
                      elevation: 2, // Adjust the elevation as needed
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Xin chào: $fullName'),
                            Text(
                              'Ngày sinh của bạn: $dayDropdownValue $monthDropdownValue $yearDropdownValue',
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Card for result and detailed information
                    Card(
                      elevation: 2, // Adjust the elevation as needed
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Số chủ đạo: $result'),
                            const SizedBox(height: 8.0),
                            Container(
                              height: 220, // Adjust the height as needed
                              child: SingleChildScrollView(
                                child: Text('Thông tin chi tiết: $info'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await fetchData();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding: const EdgeInsets.only(bottom: 0.0),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 8.0),
                  Text('Tra cứu'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
