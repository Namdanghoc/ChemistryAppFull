import 'package:chemistryapp/compounduser.dart';
import 'package:chemistryapp/addcp.dart';
import 'package:chemistryapp/listcompound.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'language.dart';
import 'package:provider/provider.dart';

List<Compounduser> searchResultsUser = [];
List<compound> searchResults = [];

class searchNamecp extends StatefulWidget {
  const searchNamecp({super.key});

  @override
  State<searchNamecp> createState() => _searchNamecpState();
}

class _searchNamecpState extends State<searchNamecp> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    loadCompoundsFromSharedPreferences();
    _loadCompounds();
  }

  _loadCompounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? compoundList = prefs.getStringList('compounds');

    if (compoundList != null) {
      setState(() {
        compoundsuser = compoundList
            .map((json) => Compounduser.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> loadCompoundsFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? compoundsJson = prefs.getStringList('compounds');

    if (compoundsJson != null) {
      List<Compounduser> loadedCompounds = compoundsJson
          .map((json) => Compounduser.fromJson(jsonDecode(json)))
          .toList();

      setState(() {
        searchResultsUser = loadedCompounds;
      });
    }
  }

  Future<void> speakCommonName(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  void search(String query) {
    // Tìm kiếm trong biến toàn cục compoundsuser
    searchResultsUser = compoundsuser
        .where((libray) =>
            libray.formula.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Tìm kiếm trong biến toàn cục Compounds
    searchResults = Compounds.where((library) =>
        library.formula.toLowerCase().contains(query.toLowerCase())).toList();

    // Cập nhật trạng thái để rebuild UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: search,
                  decoration: InputDecoration(
                    labelText: languageProvider.isEnglish
                        ? 'Enter the formula element'
                        : 'Nhập công thức hợp chất',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length + searchResultsUser.length,
                  itemBuilder: (context, index) {
                    if (index < searchResultsUser.length) {
                      // Hiển thị kết quả từ searchResultsUser
                      return ListTile(
                        title: Text(
                            "${languageProvider.isEnglish ? 'Formula' : 'Công thức'}: ${searchResultsUser[index].formula}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${languageProvider.isEnglish ? 'IUPAC Name' : 'Pháp danh'}: ${searchResultsUser[index].iupacName}",
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            String name = searchResultsUser[index].iupacName;
                            speakCommonName(name);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompoundInfoWidget(
                                formula: searchResultsUser[index].formula,
                                iupacName: searchResultsUser[index].iupacName,
                                commonName: searchResultsUser[index].commonName,
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      // Hiển thị kết quả từ searchResults
                      int adjustedIndex = index - searchResultsUser.length;
                      return ListTile(
                        title: Text(
                            "${languageProvider.isEnglish ? 'Formula' : 'Công thức'}: ${searchResults[adjustedIndex].formula}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${languageProvider.isEnglish ? 'IUPAC Name' : 'Pháp danh'}: ${searchResults[adjustedIndex].iupacname}",
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            String name =
                                searchResults[adjustedIndex].iupacname;
                            speakCommonName(name);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompoundInfoWidget(
                                formula: searchResults[adjustedIndex].formula,
                                iupacName:
                                    searchResults[adjustedIndex].iupacname,
                                commonName:
                                    searchResults[adjustedIndex].commonname,
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Chuyển đến màn hình CompoundList khi người dùng bấm nút "Add New Compound"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompoundList(),
                    ),
                  );
                },
                child: Text(
                  languageProvider.isEnglish
                      ? 'Add or Delete compound'
                      : 'Thêm hoặc Xóa hợp chất',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
