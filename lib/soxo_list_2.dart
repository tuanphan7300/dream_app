import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SoXoListScreen extends StatefulWidget {
  @override
  _SoXoListScreenState createState() => _SoXoListScreenState();
}

class _SoXoListScreenState extends State<SoXoListScreen> {
  String selectedRegion = "Miền Bắc";
  String selectedProvince = "";
  DateTime selectedDate = DateTime.now();
  Map<String, String> specialPrizes = {};
  List<String> district = [];
  List<String> area = [];

  Map<String, String> mapArea = {
    "Miền Bắc" : "MB",
    "Miền Nam" : "MN"
  };

  Map<String, dynamic> mapDistrict = {
    'Hồ Chí Minh': 'xshcm-xstp',
    'An Giang': 'xsag',
    'Bình Dương': 'xsbd',
    'Bạc Liêu': 'xsbl',
    'Bình Phước': 'xsbp',
    'Bến Tre': 'xsbt',
    'Bình Thuận': 'xsbth',
    'Cà Mau': 'xscm',
    'Cần Thơ': 'xsct',
    'Lâm Đồng - Đà Lạt': 'xsld-xsdl',
    'Đồng Nai': 'xsdn',
    'Đồng Tháp': 'xsdt',
    'Hậu Giang': 'xshg',
    'Kiên Giang': 'xskg',
    'Long An': 'xsla',
    'Sóc Trăng': 'xsst',
    'Tiền Giang': 'xstg',
    'Trà Vinh': 'xstv',
    'Vĩnh Long': 'xsvl',
    'Vũng Tàu': 'xsvt',
    'Tây Ninh': 'xstn',
  };

  @override
  void initState() {
    super.initState();
    district = mapDistrict.keys.toList();
    area = mapArea.keys.toList();

    // Gọi fetchData khi màn hình được khởi tạo
    fetchData();
  }

  DecorationImage backgroundImage = const DecorationImage(
    image: AssetImage("images/assets/backgroundsoxo.png"),  // Change the image path
    fit: BoxFit.cover,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('So Xo List'),
      ),
      body: Container(
        decoration: BoxDecoration(
        image: backgroundImage,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<String>(
                    value: selectedRegion,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRegion = newValue!;
                        if (selectedRegion == "Miền Nam") {
                          selectedProvince = district[0];
                        } else {
                          selectedProvince = '';
                        }
                      });
                    },
                    items: area.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if (selectedRegion == "Miền Nam")
                    DropdownButton<String>(
                      value: selectedProvince,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedProvince = newValue!;
                        });
                      },
                      items: district.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,  // Change the button color
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await fetchData();
                    },
                    child: const Text('Tìm kiếm', style: (TextStyle(fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Ngày tháng:', style: TextStyle(fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                        });
                    },
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Đoạn mã để hiển thị ListView với cột Title và Giá trị giải thưởng
              Expanded(
                child: ListView.builder(
                  itemCount: specialPrizes.length,
                  itemBuilder: (context, index) {
                    final key = specialPrizes.keys.elementAt(index);
                    final value = specialPrizes[key];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.orange,  // Màu sắc cho tiêu đề
                              ),
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                text: 'Số trúng: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black, // Màu cho phần "Số trúng"
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: value,
                                    style: TextStyle(fontSize: 16, color: Colors.blue), // Màu cho giá trị số trúng
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> fetchData() async {
    const url = 'https://dream-abb4snyjiq-df.a.run.app/v1/get-xoso-mb';
    final body = {
      'area': mapArea[selectedRegion] ,
      'district': mapDistrict[selectedProvince],
      'date': DateFormat('dd-MM-yyyy').format(selectedDate)
    };

    final response = await http.post(Uri.parse(url), body: jsonEncode(body));

    if (response.statusCode == 200) {
      print(response);
      final Map<String, dynamic> data = json.decode(response.body);
      print(data);
      if (data['errorCode'] == '00') {
        setState(() {
          specialPrizes = {
            'Giải đặc biệt': data['data']['special_prize'],
            'Giải nhất': data['data']['first_prize'],
            'Giải nhì': data['data']['second_prize'],
            'Giải ba': data['data']['third_prize'],
            'Giải bốn': data['data']['four_prize'],
            'Giải năm': data['data']['fifth_prize'],
            'Giải sáu': data['data']['sixth_prize'],
            'Giải bảy': data['data']['seventh_prize'],
          };
          if (data['data']['eighth_prize'] != '') {
            specialPrizes['Giải tám'] = data['data']['eighth_prize'];
          }
          if (data['data']['ninth_prize'] != '') {
            specialPrizes['Giải chín'] = data['data']['ninth_prize'];
          }
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text('Không có dữ liệu'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Đóng'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Không có dữ liệu'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );
    }
  }
}
