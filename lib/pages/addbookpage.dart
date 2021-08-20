import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:http/http.dart' as http;

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AddWidget(),
    );
  }
}

class VolumeJson {
  final int totalItems;

  final String kind;

  final List<Item> items;

  VolumeJson({this.items, this.kind, this.totalItems});

  factory VolumeJson.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['items'] as List;

    List<Item> itemList = list.map((i) => Item.fromJson(i)).toList();
    print(itemList.length);

    return VolumeJson(
        items: itemList,
        kind: parsedJson['kind'],
        totalItems: parsedJson['totalItems']);
  }
}

class Item {
  final String kind;

  final String etag;

  final VolumeInfo volumeinfo;

  Item({this.kind, this.etag, this.volumeinfo});

  factory Item.fromJson(Map<String, dynamic> parsedJson) {
    return Item(
        kind: parsedJson['kind'],
        etag: parsedJson['etag'],
        volumeinfo: VolumeInfo.fromJson(parsedJson['volumeInfo']));
  }
}

class VolumeInfo {
  final String title;

  final String publisher;

  final String printType;

  final ImageLinks image;

  VolumeInfo({
    this.printType,
    this.title,
    this.publisher,
    this.image,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> parsedJson) {
    print('GETTING DATA');
    //print(isbnList[1]);
    return VolumeInfo(
      title: parsedJson['title'],
      publisher: parsedJson['publisher'],
      printType: parsedJson['printType'],
      image: ImageLinks.fromJson(
        parsedJson['imageLinks'],
      ),
    );
  }
}

class ImageLinks {
  final String thumb;

  ImageLinks({this.thumb});

  factory ImageLinks.fromJson(Map<String, dynamic> parsedJson) {
    return ImageLinks(thumb: parsedJson['thumbnail']);
  }
}

class ISBN {
  final String iSBN13;
  final String type;

  ISBN({this.iSBN13, this.type});

  factory ISBN.fromJson(Map<String, dynamic> parsedJson) {
    return ISBN(
      iSBN13: parsedJson['identifier'],
      type: parsedJson['type'],
    );
  }
}

class AddWidget extends StatefulWidget {
  String isbn;

  AddWidget({String isbn}) {
    this.isbn = isbn;
    print("work");
  }
  @override
  _AddWidget createState() => _AddWidget();
}

class _AddWidget extends State<AddWidget> {
  String _imageController;
  TextEditingController _isbnController;
  TextEditingController _nameController;
  TextEditingController _authorController;
  TextEditingController _publisherController;
  TextEditingController _descriptionController;
  TextEditingController _categoryController;
  TextEditingController _nController;
  TextEditingController _languageController;
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    if (widget.isbn == null) {
      _isbnController = TextEditingController(text: "");
    } else {
      _isbnController = TextEditingController(text: widget.isbn);
      getRelateds(widget.isbn);
    }

    _nameController = TextEditingController(text: "");
    _authorController = TextEditingController(text: "");
    _publisherController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _categoryController = TextEditingController(text: "");
    _nController = TextEditingController(text: "");
    _languageController = TextEditingController(text: "");
  }

  Future<File> _fileFromImageUrl(String s) async {
    // generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(s));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  File _imageFile;
  Future<VolumeJson> getRelateds(String isbn) async {
    print('Im Starting');
    try {
      final jsonResponse = await http.get(
          Uri.parse('https://www.googleapis.com/books/v1/volumes?q={$isbn}'));

      var jsonBody = json.decode(jsonResponse.body);
      print(jsonBody['items'][0]);
      _nameController.text = jsonBody['items'][0]['volumeInfo']['title'];
      _authorController.text =
          jsonBody['items'][0]['volumeInfo']['authors'].toString();
      _publisherController.text =
          jsonBody['items'][0]['volumeInfo']['publisher'];
      _descriptionController.text =
          jsonBody['items'][0]['volumeInfo']['description'];
      _categoryController.text =
          jsonBody['items'][0]['volumeInfo']['categories'].toString();
      _languageController.text = jsonBody['items'][0]['volumeInfo']['language'];
      //_imageFile = File.fromUri(Uri.parse(jsonBody['items'][0]['volumeInfo']['imageLinks']['thumbnail']));
      _imageFile = await _fileFromImageUrl(
          jsonBody['items'][0]['volumeInfo']['imageLinks']['thumbnail']);
      _imageController =
          jsonBody['items'][0]['volumeInfo']['imageLinks']['thumbnail'];
      setState(() {
        _imageFile = _imageFile;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Информация по данному ISBN не найдена"),
      ));
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> uploadFile(File file) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref(_nameController.text.toString())
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print("bad");
      // e.g, e.code == 'canceled'
    }

    _imageController = await firebase_storage.FirebaseStorage.instance
        .ref(_nameController.text.toString())
        .getDownloadURL();
  }

  Future<void> getBookGoogleApi(String isbn) async {
    try {
      //json
      getRelateds(isbn);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Информация по данному ISBN не найдена"),
      ));
      // e.g, e.code == 'canceled'
    }
  }

  saveBook() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final collection = FirebaseFirestore.instance.collection('books');
    QuerySnapshot querySnap =
        await collection.where("isbn", isEqualTo: _isbnController.text).get();

    Map<String, dynamic> userData = {
      "isbn": _isbnController.text,
      "name": _nameController.text,
      "author": _authorController.text,
      "publisher": _publisherController.text,
      "description": _descriptionController.text,
      "category": _categoryController.text,
      "n": _nController.text,
      "language": _languageController.text,
      "image": _imageController,
      "login": auth.currentUser.email
    };
    if (querySnap.docs.isEmpty) {
      await _db.collection("books").add(userData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Успешно добавлено"),
      ));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Книга с таким ISBN уже добавлена"),
      ));
    }
  }

  bool t = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Добавить книгу"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_imageFile != null)
                Container(
                    padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
              IconButton(
                icon: Icon(
                  Icons.photo_library,
                  size: 30,
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
                color: Colors.pink,
              ),
              TextField(
                controller: _isbnController,
                decoration: InputDecoration(hintText: "Введите ISBN"),
              ),
              ElevatedButton(
                child: Text("Найти"),
                onPressed: () {
                  if (_isbnController.text.isNotEmpty) {
                    getBookGoogleApi(_isbnController.text);
                  }
                },
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Введите Название"),
              ),
              TextField(
                controller: _authorController,
                decoration: InputDecoration(hintText: "Введите Автора"),
              ),
              TextField(
                controller: _publisherController,
                decoration: InputDecoration(hintText: "Введите Издателя"),
              ),
              Container(
                height: 100.0,
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: "Введите Описание"),
                ),
              ),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(hintText: "Введите Категорию"),
              ),
              TextField(
                controller: _nController,
                decoration: InputDecoration(hintText: "Введите Количество"),
              ),
              TextField(
                controller: _languageController,
                decoration: InputDecoration(hintText: "Введите Язык"),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                child: Text("Загрузить"),
                onPressed: () async {
                  if (_isbnController.text.isNotEmpty &&
                      _nameController.text.isNotEmpty &&
                      _authorController.text.isNotEmpty &&
                      _nController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    await uploadFile(_imageFile);
                    saveBook();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Заполните все поля"),
                    ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
