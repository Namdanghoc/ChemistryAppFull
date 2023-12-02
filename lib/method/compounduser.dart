import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'language.dart';
import 'package:provider/provider.dart';

class CompoundInfoWidget extends StatefulWidget {
  final String formula;
  final String iupacName;
  final String commonName;

  CompoundInfoWidget({
    required this.formula,
    required this.iupacName,
    required this.commonName,
  });

  @override
  State<CompoundInfoWidget> createState() => _CompoundInfoWidgetState();
}

class _CompoundInfoWidgetState extends State<CompoundInfoWidget> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakCommonName(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.isEnglish
                ? 'Compound Information'
                : 'Thông tin hợp chất'),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[200],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Formula: ${widget.formula}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      languageProvider.isEnglish
                          ? 'IUPAC Name: '
                          : 'Tên IUPAC: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        speakCommonName(widget.iupacName);
                      },
                    ),
                    Text(
                      '${widget.iupacName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      languageProvider.isEnglish
                          ? 'Common Name: '
                          : 'Tên thông thường: ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        speakCommonName(widget.commonName);
                      },
                    ),
                    Text(
                      '${widget.commonName}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
