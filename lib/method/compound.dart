import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'detailcp.dart';
import 'language.dart';
import 'package:provider/provider.dart';

class Compounds extends StatefulWidget {
  const Compounds({Key? key}) : super(key: key);

  @override
  _CompoundsState createState() => _CompoundsState();
}

class _CompoundsState extends State<Compounds> {
  final FlutterTts flutterTts = FlutterTts();
  TextEditingController _textEditingController = TextEditingController();
  List<Map<String, dynamic>> _compounds = [];
  String formulasearch = '';
  List<String> _synonyms = [];
  List<String> _first15Synonyms = [];
  List<List<String>> _synonymsList = [];
  Map<int, List<String>> _synonymsMap = {};

  Future<void> speakCommonName(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  Future<void> getCompoundNames(int cid) async {
    var url = Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/$cid/synonyms/JSON');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        var data = json.decode(response.body);
        _synonyms =
            data['InformationList']['Information'][0]['Synonym'].cast<String>();
        _synonymsMap[cid] = _synonyms;
        _synonymsList.add(_synonyms);
        _first15Synonyms = _synonyms.take(15).toList();
      });
    } else {
      print(
          'Failed to fetch compound names. Status code: ${response.statusCode}');
    }
  }

  void _searchCompound() async {
    String formula = _textEditingController.text;
    var compoundDetailsUrl = Uri.parse(
        'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/$formula/property/IUPACName,MolecularFormula,MolecularWeight,inchi,CanonicalSMILES,IsomericSMILES,title/JSON');
    var compoundDetailsResponse = await http.get(compoundDetailsUrl);

    if (compoundDetailsResponse.statusCode == 200) {
      var compoundData = json.decode(compoundDetailsResponse.body);
      setState(() {
        formulasearch = formula;
        _compounds = compoundData['PropertyTable']['Properties']
            .cast<Map<String, dynamic>>();
      });
      // Lấy CID từ dữ liệu compoundDetailsResponse
      int cid = compoundData['PropertyTable']['Properties'][0]['CID'];
      // Gọi hàm getCompoundNames để lấy tên đồng nghĩa của hợp chất
      await getCompoundNames(cid);
    } else {
      setState(() {
        _compounds = [];
      });
    }
  }

  @override
  Widget _buildSynonymsList(int cid) {
    return Wrap(
      children: _synonymsMap[cid]
              ?.take(15)
              .map((synonym) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextButton(
                      onPressed: () {
                        // Gọi hàm phát âm khi bấm vào nút
                        speakCommonName(synonym);
                      },
                      child: Text(
                        synonym,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight:
                                FontWeight.bold // Thay đổi màu sắc tại đây
                            ),
                      ),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurple[200]!,
                        ),
                      ),
                    ),
                  ))
              .toList() ??
          [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: languageProvider.isEnglish
                        ? 'Enter formula or compound name. Example: (NH4)2SO4'
                        : 'Nhập công thức hoặc tên hợp chất. Ví dụ: (NH4)2SO4',
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _searchCompound,
                  child: Text(
                    languageProvider.isEnglish ? 'Search' : 'Tìm kiếm',
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple[200]!,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _compounds.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            languageProvider.isEnglish
                                ? 'Formula : ${formulasearch}' ?? ''
                                : 'Công thức : ${formulasearch}' ?? '',
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CID PUBCHEM: ${_compounds[index]['CID']}',
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                languageProvider.isEnglish
                                    ? 'Iupac name: ${_compounds[index]['IUPACName']}' ??
                                        'Iupac name: ${_compounds[index]['Title']}'
                                    : 'Tên IUPAC: ${_compounds[index]['IUPACName']}' ??
                                        'Tên IUPAC: ${_compounds[index]['Title']}',
                              ),
                              SizedBox(height: 5),
                              Text(
                                languageProvider.isEnglish
                                    ? 'Synonyms:'
                                    : 'Đồng nghĩa:',
                              ),
                              // Hiển thị danh sách đồng nghĩa bằng ListView.builder
                              _buildSynonymsList(_compounds[index]['CID']),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompoundDetails(
                                  formula: formulasearch,
                                  compound: _compounds[index],
                                  first15Synonyms: _first15Synonyms,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
