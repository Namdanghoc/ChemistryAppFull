import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'language.dart';
import 'package:provider/provider.dart';

List<Compounduser> compoundsuser = [];

class Compounduser {
  final String formula;
  final String iupacName;
  final String commonName;

  Compounduser(this.formula, this.iupacName, this.commonName);

  Map<String, dynamic> toJson() {
    return {
      'formula': formula,
      'iupacName': iupacName,
      'commonName': commonName,
    };
  }

  factory Compounduser.fromJson(Map<String, dynamic> json) {
    return Compounduser(
      json['formula'],
      json['iupacName'],
      json['commonName'],
    );
  }
}

class CompoundList extends StatefulWidget {
  @override
  _CompoundListState createState() => _CompoundListState();
}

class _CompoundListState extends State<CompoundList> {
  List<Compounduser> searchResultsUser = [];
  final FlutterTts flutterTts = FlutterTts();

  Future<void> speakCommonName(String text) async {
    await flutterTts.setLanguage("en-GB");
    await flutterTts.speak(text);
  }

  // void search(String query) {
  //   // Tìm kiếm trong biến toàn cục compoundsuser
  //   searchResultsUser = compoundsuser
  //       .where((compound) =>
  //           compound.formula.toLowerCase().contains(query.toLowerCase()))
  //       .toList();

  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
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

  _saveCompounds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> compoundList =
        compoundsuser.map((compound) => jsonEncode(compound.toJson())).toList();
    prefs.setStringList('compounds', compoundList);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(languageProvider.isEnglish
                ? 'Recently Added Compounds'
                : 'Các hợp chất đã thêm gần đây'),
            centerTitle: true,
            backgroundColor: Colors.deepPurple[200],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: compoundsuser.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(compoundsuser[index].formula),
                        subtitle: Text(compoundsuser[index].iupacName),
                        trailing: IconButton(
                          onPressed: () {
                            speakCommonName(compoundsuser[index].iupacName);
                          },
                          icon: Icon(Icons.volume_up),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _showAddCompoundDialog(context);
                },
                child: Text(languageProvider.isEnglish
                    ? 'Add Compound'
                    : 'Thêm hợp chất'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showDeleteCompoundDialog(context);
                },
                child: Text(languageProvider.isEnglish
                    ? 'Delete Compound'
                    : 'Xóa hợp chất'),
              ),
            ],
          ),
        );
      },
    );
  }

  //Hàm hiển thị thông báo thêm một hợp chất mới
  Future<void> _showAddCompoundDialog(BuildContext context) async {
    TextEditingController formulaController = TextEditingController();
    TextEditingController iupacNameController = TextEditingController();
    TextEditingController commonNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, _) {
            return AlertDialog(
              title: Text(languageProvider.isEnglish
                  ? 'Add New Compound'
                  : 'Thêm hợp chất mới'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languageProvider.isEnglish ? 'Formula:' : 'Công thức:'),
                  TextField(controller: formulaController),
                  SizedBox(height: 10),
                  Text(languageProvider.isEnglish
                      ? 'IUPAC Name:'
                      : 'Pháp danh:'),
                  TextField(controller: iupacNameController),
                  SizedBox(height: 10),
                  Text(languageProvider.isEnglish
                      ? 'Common Name:'
                      : 'Tên thông thường:'),
                  TextField(controller: commonNameController),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(languageProvider.isEnglish ? 'Cancel' : 'Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Compounduser newCompound = Compounduser(
                      formulaController.text,
                      iupacNameController.text,
                      commonNameController.text,
                    );
                    setState(() {
                      compoundsuser.add(newCompound);
                      _saveCompounds(); // Lưu trạng thái mới sau khi thêm
                    });
                    Navigator.pop(context);
                  },
                  child: Text(languageProvider.isEnglish ? 'Add' : 'Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //Hàm hiển thị thông báo xóa một hợp chất mới
  Future<void> _showDeleteCompoundDialog(BuildContext context) async {
    TextEditingController formulaController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, _) {
            return AlertDialog(
              title: Text(languageProvider.isEnglish
                  ? 'Delete Compound'
                  : 'Xóa hợp chất'),
              content: Column(
                children: [
                  Text(languageProvider.isEnglish
                      ? 'Are you sure you want to delete this compound?'
                      : 'Bạn có chắc chắn muốn xóa hợp chất này không?'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(languageProvider.isEnglish ? 'Formula:' : 'Công thức:'),
                  TextField(controller: formulaController),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(languageProvider.isEnglish ? 'Cancel' : 'Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Xác định công thức hợp chất cần xóa
                    String formula = formulaController.text;
                    setState(() {
                      // Loại bỏ hợp chất khỏi danh sách
                      compoundsuser.removeWhere(
                          (compound) => compound.formula == formula);
                      _saveCompounds(); // Lưu trạng thái mới sau khi xóa
                    });
                    Navigator.pop(context);
                  },
                  child: Text(languageProvider.isEnglish ? 'Delete' : 'Xóa'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
