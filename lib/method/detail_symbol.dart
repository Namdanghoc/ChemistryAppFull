import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'chemical_symbol.dart';
import 'main.dart';
import 'language.dart';
import 'package:provider/provider.dart';

class DetailSymbol extends StatelessWidget {
  final chemicalsymbol detailsymbol;
  DetailSymbol({required this.detailsymbol});

  final player = AudioPlayer();

  void playSound() async {
    await player
        .play(AssetSource('mp3_elements/${detailsymbol.nomenclature}.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${detailsymbol.symbol}'),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[200],
            actions: [
              ElevatedButton(
                onPressed: () {
                  playSound();
                },
                child: Icon(Icons.volume_up),
              )
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 500,
                  height: 500,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/${detailsymbol.chemicalelementnumber}.jpg',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  languageProvider.isEnglish
                      ? 'Common name: ${detailsymbol.nomenclature}'
                      : 'Pháp danh: ${detailsymbol.nomenclature}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'Atomic number: ${detailsymbol.chemicalelementnumber}'
                      : 'Số thứ tự trong bảng tuần hoàn: ${detailsymbol.chemicalelementnumber}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'Atomic mass: ${detailsymbol.atomicblock}'
                      : 'Nguyên tử khối: ${detailsymbol.atomicblock}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'Color: ${detailsymbol.color}'
                      : 'Màu sắc: ${detailsymbol.color}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'State: ${detailsymbol.state}'
                      : 'Trạng thái: ${detailsymbol.state}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'Classification: ${detailsymbol.classify}'
                      : 'Phân loại: ${detailsymbol.classify}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  languageProvider.isEnglish
                      ? 'Electron configuration: ${detailsymbol.electron}'
                      : 'Cấu hình e: ${detailsymbol.electron}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.deepPurple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                  child: Text(
                    languageProvider.isEnglish
                        ? 'Back to menu'
                        : 'Quay lại menu',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
