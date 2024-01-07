import 'package:flutter/material.dart';
import 'dream_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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

                // Thiết lập title và text tương ứng với mỗi index
                if (index == 0) {
                  image = 'images/assets/dream.png';
                  title = 'Giải mã giấc mơ';
                  text = 'Giải mã tất cả các giấc mơ của bạn để đưa bạn chạm tới ước mơ của chính bản thân mình';
                } else if (index == 1) {
                  image = 'images/assets/thansohoc.png';
                  title = 'Giải mã thần số học';
                  text = 'Giải mã tất cả các vấn đề liên quan đến bản thân bạn';
                } else if (index == 2) {
                  image = 'images/assets/soxo.png';
                  title = 'Kết quả sổ số';
                  text = 'Để biết giấc mơ của bạn đang nằm ở đâu...';
                }

                return ListTile(
                  leading: Image.asset(image), // Hình ảnh đại diện cho bài viết
                  title: Text(title), // Tiêu đề của bài viết
                  subtitle: Text(text), // Phụ đề của bài viết
                  onTap: () {
                    // Chuyển đến màn hình mới khi được nhấn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DreamList(apiUrl: 'https://dream-abb4snyjiq-df.a.run.app/v1/get-dream'),
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
