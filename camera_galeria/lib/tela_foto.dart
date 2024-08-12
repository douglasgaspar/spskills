//Biblioteca para poder montar o arquivo File
import 'dart:io';
import 'package:flutter/material.dart';

class TelaFoto extends StatelessWidget {
  late String arquivo;
  //Construtor
  TelaFoto({super.key, required this.arquivo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visualização da foto')),
      body:
          //Componente da tela para visualizar a imagem da foto
          Image.file(File(arquivo)),
    );
  }
}
