import 'package:flutter/material.dart';
import 'package:image/model/model.dart' as model;

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.initialSearchImage,
    required this.query,
    required this.searchFunction,
  });

  final List<dynamic> initialSearchImage;
  final String query;
  final Future<model.ImageData> Function(String, int) searchFunction;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _searchImage = [];
  int _page = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchImage = List.from(widget.initialSearchImage);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _page++;
      await _fetchMoreImages();
    }
  }

  Future<void> _fetchMoreImages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final newImages = await widget.searchFunction(widget.query, _page);
      setState(() {
        _searchImage.addAll(newImages.data);
      });
    } catch (e) {
      debugPrint('Error fetching images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Search",
        style: TextStyle(fontSize: 20, color: Colors.white)
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _searchImage.length,
        itemBuilder: (context, index) {
          final image = _searchImage[index].images[0].link;
          return Card(
            color:Color(0xFF121211),
            child: ListTile(
              title: Text(_searchImage[index].title,
              style: const TextStyle(color: Colors.white)
              ),
              leading: image != null ? Image.network(image) : null,
            ),
          );
        },
      ),
    );
  }
}
