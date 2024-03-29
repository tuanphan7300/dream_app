import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DreamList extends StatefulWidget {
  final String apiUrl;

  const DreamList({Key? key, required this.apiUrl}) : super(key: key);

  @override
  _DreamListState createState() => _DreamListState();
}

class _DreamListState extends State<DreamList> {
  late Future<List<Map<String, dynamic>>> dreamList;
  List<Map<String, dynamic>> dreams = [];
  int totalItem = 0;
  int currentPage = 1;
  int rowsPerPage = 10;
  String searchValue = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAndDisplayData();
  }

  DecorationImage backgroundImage = const DecorationImage(
    image: AssetImage("images/assets/backgoundpupur.jpg"),  // Change the image path
    fit: BoxFit.cover,
  );


  Future<void> fetchAndDisplayData({String? searchQuery}) async {
    try {
      String apiUrl = widget.apiUrl;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        searchValue = searchQuery;
        apiUrl += '?search=$searchQuery';
      }

      apiUrl += apiUrl.contains('?') ? '&page=$currentPage' : '?page=$currentPage';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data']['Data'] is List) {
          setState(() {
            dreams = List<Map<String, dynamic>>.from(responseData['data']['Data']);
            totalItem = responseData['data']['Total'] ?? 0;
          });
        } else {
          showErrorSnackBar("Invalid response format");
        }
      } else {
        showErrorSnackBar("Failed to load data");
      }
    } catch (e) {
      showErrorSnackBar("Error: $e");
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  List<Map<String, dynamic>> getCurrentPageData() {
    final startIndex = (currentPage - 1) * rowsPerPage;
    final endIndex = startIndex + rowsPerPage;
    final endClamped = endIndex.clamp(0, dreams.length);

    return dreams.sublist(startIndex.clamp(0, dreams.length), endClamped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm giấc mơ cho bạn'),
        leading: const BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
        image: backgroundImage,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Nhập từ khóa ví dụ: "Tiền"',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(
                        fontSize: 16.0, // Kích thước chữ
                        fontWeight: FontWeight.bold, // Trọng lượng chữ
                        color: Colors.orange, // Màu chữ
                        //Thêm các thuộc tính khác của TextStyle nếu bạn muốn tùy chỉnh thêm
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      try {
                        // Gọi API với tham số tìm kiếm
                        //set lại page = 1
                        currentPage = 1;
                        await fetchAndDisplayData(searchQuery: searchController.text);
                      } catch (e) {
                        // Xử lý lỗi nếu cần thiết
                        print('Error fetching and displaying data: $e');
                      }
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10.0,0,10.0,20.0),
              child: Row(
                children: [
                  Text("Các con số cho giấc mơ của bạn", style: TextStyle(color: Colors.pink, fontSize: 16, fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(), // Gạch chân ngăn cách dưới mỗi item
            Expanded(
              child: ListView.builder(
                itemCount: dreams.length,
                itemBuilder: (context, index) {
                  final dream = dreams[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(dream['name'], style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(dream['number'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
                      ),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: currentPage < (totalItem / rowsPerPage).ceil()
                        ? () async {
                            setState(() {

                              currentPage = (currentPage + 1).clamp(1, (totalItem / rowsPerPage).ceil());
                              print('Next Button Pressed. Current Page: $currentPage');
                            });
                            await fetchAndDisplayData(searchQuery: searchValue);
                          }
                        : null,
                  ),
                  Text('Page $currentPage',style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: currentPage > 1
                        ? () async {
                            setState(() {
                              currentPage = (currentPage - 1).clamp(1, (totalItem / rowsPerPage).ceil());
                              print('Next Button Pressed. Current Page: $currentPage');
                            });
                            await fetchAndDisplayData(searchQuery: searchValue);
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
