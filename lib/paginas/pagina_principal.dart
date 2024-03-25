import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  int _selectedIndex = 0;
  File? imagem;
  String caminhoImagem = '';

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      CroppedFile imagemCortada = await cortarImagem(File(pickedImage.path));
      setState(() {
        imagem = File(imagemCortada.path);
        caminhoImagem = imagemCortada.path;
      });
    }
  }

  Future<void> getImageGalery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      CroppedFile imagemCortada = await cortarImagem(File(pickedImage.path));

      setState(() {
        imagem = File(imagemCortada.path);
        caminhoImagem = imagemCortada.path;
      });
    }
  }

  cortarImagem(File imagem) async {
    return await ImageCropper().cropImage(
        sourcePath: imagem.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 70,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Cortar Imagem",
              toolbarWidgetColor: Colors.white,
              toolbarColor: const Color.fromARGB(255, 85, 7, 175),
              initAspectRatio: CropAspectRatioPreset.square),
          IOSUiSettings(
            title: "Cortar Imagem",
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 85, 7, 175),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Container(
            // Conteúdo da primeira página
            alignment: Alignment.center,
            child: const Text("Página 1"),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        label: const Text("Nome")),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    maxLines: null,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        label: const Text("No que você está pensando...")),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => {getImageGalery()},
                          child: const Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.collections),
                                Text("Abrir Galeria"),
                              ],
                            ),
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                          onPressed: () => {getImage()},
                          child: const Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt),
                                Text("Tirar Foto"),
                              ],
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Image.file(File(caminhoImagem)),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () => {},
                      child: const Padding(
                        padding: EdgeInsets.all(7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.near_me),
                            Text("Publicar"),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.public),
                ],
              ),
              label: "Publicações"),
          BottomNavigationBarItem(
              icon: Column(
                children: [
                  Icon(Icons.add_a_photo),
                ],
              ),
              label: "Publicar"),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
