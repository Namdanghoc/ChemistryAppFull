import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'language.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          Provider.of<LanguageProvider>(context).isEnglish
              ? 'Change Language'
              : 'Chuyển đổi ngôn ngữ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Provider.of<LanguageProvider>(context).isEnglish
                        ? 'Change to Vietnamese'
                        : 'Chuyển sang Tiếng Anh',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20),
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
                      Provider.of<LanguageProvider>(context, listen: false)
                          .toggleLanguage();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        Provider.of<LanguageProvider>(context).isEnglish
                            ? 'Chuyển sang Tiếng Việt'
                            : 'Change to English',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
