//Biblioteca para poder montar o arquivo File
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TelaFoto extends StatelessWidget {
  late String arquivo;
  //Construtor
  TelaFoto({super.key, required this.arquivo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Visualização da foto')),
        body: Column(
          children: [
            //Componente da tela para visualizar a imagem da foto
            Image.file(File(arquivo)),
            ElevatedButton(
              onPressed: () async {
                Uint8List captureImage = (File(arquivo)).readAsBytesSync();

                //Directory? localSalvar = await getExternalStorageDirectory();
                //final path = '$localSalvar/captured1.png';
                int nome = DateTime.now().millisecondsSinceEpoch;
                var path = '/storage/emulated/0/DCIM/SP_Skills/$nome.png';
                final imagePath = await File(path).create(recursive: true);

                File gravado = await imagePath.writeAsBytes(captureImage);
                if (await gravado.exists()) {
                  Fluttertoast.showToast(msg: "Arquivo salvo na pasta DCIM");
                } else {
                  Fluttertoast.showToast(msg: "Erro ao salvar arquivo");
                }
              },
              child: const Text("Salvar na galeria"),
            )
          ],
        ));
  }
}
