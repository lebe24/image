import 'package:flutter/material.dart';
import 'package:image/components/image_card.dart';
import 'package:image/components/image_view.dart';
import 'package:image/model/model.dart' as model;
import 'package:image/services/services.dart';
import 'package:image/view/SearchPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.fetchPopularImages, this.searchImages});

  final Future<model.ImageData> Function(String section, String sort, String window)? fetchPopularImages;
  final Future<model.ImageData> Function(String query, int page)? searchImages;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  final List<dynamic> _images = [];
  int _page = 0;
  String _searchQuery = '';
  String title = "Popular";

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _page = 0;
    });
    _searchImage();
  }


  Future<void> _fetchImages({
    String section = "hot",
    String sort = "viral",
    String window = "day",
  }) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final response = await (widget.fetchPopularImages ?? getPopular)(section, sort, window);
      setState(() {
        _images.addAll(response.data);
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchImage() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final response = await (widget.searchImages ?? search)(_searchQuery, _page);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchPage(
            initialSearchImage: response.data,
            query: _searchQuery,
            searchFunction: widget.searchImages ?? search,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              key: const Key('searchField'),
              decoration: InputDecoration(
                hintText: 'Search images...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: _onSearch,
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _images.isNotEmpty
                  ? GridView.builder(
                      key: const Key('gridView'),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _images.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _images.length) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final image = _images[index].images[0].link;
                        return image.toLowerCase().endsWith('.mp4')
                            ? GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(data: _images[index]),) ),
                              child: PhotoCard(child: Image.network("https://i.imgur.com/44avi6S.png")))
                            : GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(data: _images[index]),) ),
                              child: PhotoCard(child: Image.network(image,fit: BoxFit.cover,)));
                      }
                    )
                  : const Center(
                      key: Key('emptyState'),
                      child: Text("No images found."),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
