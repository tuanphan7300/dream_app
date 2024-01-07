import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Trang chủ'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Xử lý khi người dùng nhấn nút tìm kiếm
              },
            ),
            SearchWidget(), // Thêm widget ô nhập liệu tìm kiếm vào thanh AppBar
          ],
        ),
        body: ListView(
          children: [
            NewsItem(
              title: 'HSBC trở lại cho vay tiêu dùng tại Mỹ',
              author: 'Jackson Hewitt',
              publishedAt: '24/12/2023',
            ),
            NewsItem(
              title: 'Apple ra mắt iPhone 15 mới',
              author: 'Tim Cook',
              publishedAt: '20/12/2023',
            ),
            NewsItem(
              title: 'Google ra mắt Android 14',
              author: 'Sundar Pichai',
              publishedAt: '15/12/2023',
            ),
          ],
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String title;
  final String author;
  final String publishedAt;

  NewsItem({
    required this.title,
    required this.author,
    required this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(author),
      trailing: Text(publishedAt),
      onTap: () {
        // Mở trang chi tiết tin tức
      },
    );
  }
}

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        // Xử lý khi người dùng nhấn nút tìm kiếm
        showSearch(context: context, delegate: CustomSearchDelegate());
      },
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Xử lý kết quả tìm kiếm và hiển thị
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Gợi ý khi người dùng nhập liệu
    return Container();
  }
}
