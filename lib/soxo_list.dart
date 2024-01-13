import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class Region {
  final String key;
  final String value;

  Region(this.key, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Region &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông Tin Số Sổ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SoXoList(),
    );
  }
}

class SoXoList extends StatefulWidget {
  @override
  _SoXoListState createState() => _SoXoListState();
}

class _SoXoListState extends State<SoXoList> {
  DateTime selectedDate = DateTime.now();
  Region selectedRegion = Region('MB', 'Miền Bắc');
  String selectedProvince = '';
  bool showProvinceDropdown = false;

  // Kết quả từ API
  String specialPrize = '';
  String firstPrize = '';
  String secondPrize = '';
  String thirdPrize = '';
  String fourPrize = '';
  String fifthPrize = '';
  String sixthPrize = '';
  String seventhPrize = '';

  List<Region> regions = [
    Region('MB', 'Miền Bắc'),
    Region('MN', 'Miền Nam'),
  ];

  Map<String, String> provinceMapping = {
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
    _initDefaultDateAndFetchData();
  }

  Future<void> _initDefaultDateAndFetchData() async {
    await _fetchSoXoResult(); // Gọi API ngay khi mở ứng dụng
  }

  Future<void> _fetchSoXoResult() async {
    final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    final Map<String, dynamic> requestBody = {
      'date': formattedDate,
      'area': selectedRegion.key,
      'district': provinceMapping[selectedProvince] ?? '',
    };

    print('API Request Params: $requestBody'); // In giá trị của params

    final response = await http.post(
      Uri.parse('https://dream-abb4snyjiq-df.a.run.app/v1/get-xoso-mb'),
      body: json.encode(requestBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData); // In ra dữ liệu từ API

      setState(() {
        specialPrize = responseData['data']['special_prize'];
        firstPrize = responseData['data']['first_prize'];
        secondPrize = responseData['data']['second_prize'];
        thirdPrize = responseData['data']['third_prize'];
        fourPrize = responseData['data']['four_prize'];
        fifthPrize = responseData['data']['fifth_prize'];
        sixthPrize = responseData['data']['sixth_prize'];
        seventhPrize = responseData['data']['seventh_prize'];
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Không có dữ liệu.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin số sổ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDropdown<Region>(
                    value: selectedRegion,
                    onChanged: (Region? newValue) {
                      setState(() {
                        selectedRegion = newValue!;
                        if (selectedRegion.key == 'MN') {
                          showProvinceDropdown = true;
                          selectedProvince = provinceMapping.keys.first;
                        } else {
                          selectedRegion = Region('MB', 'Miền Bắc');
                          showProvinceDropdown = false;
                          selectedProvince = '';
                        }
                      });
                    },
                    items: regions.map((Region region) {
                      return DropdownMenuItem<Region>(
                        key: ValueKey(region),
                        value: region,
                        child: Text(region.value),
                      );
                    }).toList(),
                  ),
                ),
                if (showProvinceDropdown)
                  Expanded(
                    child: _buildDropdown<String>(
                      value: selectedProvince,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedProvince = newValue!;
                        });
                      },
                      items: provinceMapping.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    child: const Text('Chọn ngày'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedRegion.key == 'MB' || selectedRegion.key == 'MN' && selectedProvince != '') {
                        _fetchSoXoResult();
                      } else if (selectedRegion.key == 'MN' && selectedProvince == '') {
                        // Hiển thị thông báo yêu cầu chọn tỉnh khi chọn Miền Nam.
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Thông báo'),
                            content: const Text('Vui lòng chọn tỉnh khi chọn Miền Nam.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    child: const Text('Tìm kiếm'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Kết quả xổ số ngày ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Thêm một khoảng cách nhỏ (nếu cần)
            Expanded(
              child: ListView(
                children: [
                  _buildPrizeTile('Giải đặc biệt', specialPrize),
                  _buildPrizeTile('Giải nhất', firstPrize),
                  _buildPrizeTile('Giải nhì', secondPrize),
                  _buildPrizeTile('Giải ba', thirdPrize),
                  _buildPrizeTile('Giải tư', fourPrize),
                  _buildPrizeTile('Giải năm', fifthPrize),
                  _buildPrizeTile('Giải sáu', sixthPrize),
                  _buildPrizeTile('Giải bảy', seventhPrize),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required ValueChanged<T?> onChanged,
    required List<DropdownMenuItem<T>> items,
  }) {
    return DropdownButtonFormField<T>(
      key: ValueKey(value),
      value: value,
      onChanged: onChanged,
      items: items,
    );
  }

// Thay đổi hàm _buildPrizeTile như sau:

  Widget _buildPrizeTile(String title, String value) {
    List<String> prizeValues = value.split(' ');

    if ((title == 'Giải ba' || title == 'Giải năm') && prizeValues.length > 3) {
      List<Widget> rows = [];
      for (int i = 0; i < prizeValues.length; i += 3) {
        List<String> rowValues = prizeValues.sublist(
          i,
          i + 3 > prizeValues.length ? prizeValues.length : i + 3,
        );
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowValues.map((String val) {
            return Text(
              val,
              style: _getPrizeTextStyle(title),
            );
          }).toList(),
        ));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != 'Giải đặc biệt') const Divider(),
          ListTile(
            title: Text(
              title,
              style: _getTitleTextStyle(title),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rows,
            ),
          ),
        ],
      );
    }

    if (title == 'Giải tư' && prizeValues.length > 3) {
      List<Widget> rows = [];
      for (int i = 0; i < prizeValues.length; i += 3) {
        List<String> rowValues = prizeValues.sublist(
          i,
          i + 3 > prizeValues.length ? prizeValues.length : i + 3,
        );

        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: rowValues.map((String val) {
            return Text(
              val,
              style: _getPrizeTextStyle(title),
            );
          }).toList(),
        ));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != 'Giải đặc biệt') const Divider(),
          Text(
            title,
            style: _getTitleTextStyle(title),
          ),
          ...rows, // Sử dụng spread operator để thêm tất cả các dòng vào Column
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != 'Giải đặc biệt') const Divider(),
        ListTile(
          title: Text(
            title,
            style: _getTitleTextStyle(title),
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: prizeValues.map((String val) {
              return Text(
                val,
                style: _getPrizeTextStyle(title),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


TextStyle _getTitleTextStyle(String title) {
  // Define your title text styles here based on the title
  if (title == 'Giải đặc biệt') {
    return const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red);
  } else if (title == 'Giải nhất') {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue);
  }
  // Add more styles for other titles as needed
  return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}

TextStyle _getPrizeTextStyle(String title) {
  // Define your prize value text styles here based on the title
  if (title == 'Giải đặc biệt') {
    return const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red);
  } else if (title == 'Giải nhất') {
    return const TextStyle(fontSize: 14, color: Colors.blue);
  }
  // Add more styles for other titles as needed
  return const TextStyle(fontSize: 14);
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
