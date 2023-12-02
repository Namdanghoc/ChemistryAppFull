import 'package:flutter/material.dart';
import 'chemical_symbol.dart';
import 'detail_symbol.dart';
import 'package:audioplayers/audioplayers.dart';
import 'language.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<chemicalsymbol> searchResults = [];
  final player = AudioPlayer();

  void search(String query) {
    setState(() {
      searchResults = libary
          .where((libary) =>
              libary.symbol.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void navigateToSymbolDetail(chemicalsymbol detailsymbol) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailSymbol(detailsymbol: detailsymbol),
      ),
    );
  }

  void Read(String name) async {
    await player.play(AssetSource('mp3_elements/${name}.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, _) {
                return TextField(
                  onChanged: search,
                  decoration: InputDecoration(
                    labelText: languageProvider.isEnglish
                        ? 'Enter the symbol element'
                        : 'Nhập ký hiệu nguyên tố',
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<LanguageProvider>(
              builder: (context, languageProvider, _) {
                return ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        languageProvider.isEnglish
                            ? 'Element symbol: ${searchResults[index].symbol}, Name: ${searchResults[index].nomenclature}'
                            : 'Kí hiệu: ${searchResults[index].symbol}, Tên gọi: ${searchResults[index].nomenclature}',
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.isEnglish
                                ? 'Serial number in the table of chemical elements: ${searchResults[index].chemicalelementnumber}'
                                : "Số thự tự trong bảng tuần hoàn: ${searchResults[index].chemicalelementnumber}",
                          ),
                          Text(
                            languageProvider.isEnglish
                                ? 'Atomic Block: ${searchResults[index].atomicblock}'
                                : "Nguyên tử khối: ${searchResults[index].atomicblock}",
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          String name = searchResults[index].nomenclature;
                          Read(name);
                        },
                      ),
                      onTap: () {
                        navigateToSymbolDetail(searchResults[index]);
                      },
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
