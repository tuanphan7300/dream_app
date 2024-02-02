import 'package:flutter/material.dart';
import 'dream_list.dart';
import 'soxo_list_2.dart';
import 'thansohoc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Giải mã giấc mơ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đại gia vietllot Tuấn Phan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search all articles...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Số lượng bài viết
              itemBuilder: (context, index) {
                String image = "";
                String title = "";
                String text = "";
                late Widget
                    destinationScreen; // Use 'late' to indicate that the variable will be assigned before use

                // Thiết lập title và text tương ứng với mỗi index
                if (index == 0) {
                  image = 'images/assets/dream.png';
                  title = 'Giải mã giấc mơ';
                  text =
                      'Giải mã tất cả các giấc mơ của bạn để đưa bạn chạm tới ước mơ của chính bản thân mình';
                  destinationScreen = const DreamList(
                      apiUrl:
                          'https://dream-abb4snyjiq-df.a.run.app/v1/get-dream');
                } else if (index == 1) {
                  image = 'images/assets/thansohoc.png';
                  title = 'Giải mã thần số học';
                  text = 'Giải mã tất cả các vấn đề liên quan đến bản thân bạn';
                  destinationScreen = const Numerology();
                } else if (index == 2) {
                  image = 'images/assets/soxo.png';
                  title = 'Kết quả sổ số';
                  text = 'Để biết giấc mơ của bạn đang nằm ở đâu...';
                  destinationScreen = SoXoListScreen();
                }

                return ListTile(
                  leading: Image.asset(image),
                  title: Text(title),
                  subtitle: Text(text),
                  onTap: () {
                    // Chuyển đến màn hình tương ứng khi được nhấn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => destinationScreen,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
