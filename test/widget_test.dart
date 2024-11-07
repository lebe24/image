import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/model/model.dart' as model;
import 'package:image/view/Home.dart';
import 'package:mockito/mockito.dart';

// Mock Service class
class MockService extends Mock {
  Future<model.ImageData> getPopular(String section, String sort, String window);
  Future<model.ImageData> search(String query, int page);
}

void main() {
  late MockService mockService;

  setUp(() {
    mockService = MockService();
  });

  testWidgets('Displays popular images on load', (WidgetTester tester) async {
    final data = model.Datum(id: '', title: '', cover: '' ,images: []);
    final mockPopularResponse = model.ImageData(
      data: [
        data,
      ], success: true, status: 200);

    when(mockService.getPopular("hot", "viral", "day")).thenAnswer((_) async => mockPopularResponse);

    await tester.pumpWidget(MaterialApp(
      home: HomePage(
        fetchPopularImages: mockService.getPopular,
        searchImages: mockService.search,
      ),
    ));

    await tester.pumpAndSettle();

    // Verify grid view is displayed with an image
    expect(find.byKey(const Key('gridView')), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('Displays search results when a search query is entered', (WidgetTester tester) async {
    final data = model.Datum(id: '', title: '', cover: '' ,images: []);
    final mockSearchResponse = model.ImageData(
      data: [
        data,
      ], success: true, status: 200);

    when(mockService.search("google", 1)).thenAnswer((_) async => mockSearchResponse);

    await tester.pumpWidget(MaterialApp(
      home: HomePage(searchImages: mockService.search),
    ));

    await tester.enterText(find.byKey(const Key('searchField')), 'Nature');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify that the search page is shown
    expect(find.text('Search Image 1'), findsOneWidget);
  });

}
