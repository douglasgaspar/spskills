//Criar um arquivo .dart para armazenar as configurações de cor de cada tema
//o arquivo criado foi: temas.dart nas pasta lib

import 'package:flutter/material.dart';
//Biblioteca para controlar o estado do tema e recuperar o valor do dispositivo
import 'package:provider/provider.dart';
//Biblioteca para exibir mensagem via Toast
import 'package:fluttertoast/fluttertoast.dart';
//Importar a classe dos temas
import 'selecionatema.dart';

//Variável para armazenar a situaçao atual do tema
bool temaEscuro = false;
//Objeto para indicar o nome do tema selecionado
String corTemaAtual = "Claro";
//Objeto global para armazenar o tema escolhido
EscolheTema escolheTemaGlobal = EscolheTema();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EscolheTema(), //Cria objeto da classe EscolheTema
      child: Consumer<EscolheTema>(
          builder: (context, EscolheTema themeNotifier, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          //Indicação de qual tema será usado, escuro ou claro de acordo com o que foi armazenado por último
          theme: themeNotifier.temaEscuro
              ? ThemeData(
                  brightness: Brightness.dark,
                )
              : ThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.green,
                  primarySwatch: Colors.green),
          debugShowCheckedModeBanner: false,
          home: const TemaShared(
            title: "Tema e armazenamento local",
          ),
        );
      }),
    );
  }
}

class TemaShared extends StatefulWidget {
  const TemaShared({super.key, required this.title});
  final String title;

  @override
  State<TemaShared> createState() => _TemaSharedState();
}

class _TemaSharedState extends State<TemaShared> {
  //Método que irá alterar os valores de acordo com a mudança do Switch
  void alteraTema(bool valorSwitch) {
    temaEscuro = valorSwitch;
    //Altera o tema na tela cada vez que muda o Switch
    escolheTemaGlobal.temaEscuro
        ? escolheTemaGlobal.temaEscuro = false
        : escolheTemaGlobal.temaEscuro = true;

    //Muda o Switch e exibe a mensagem no Toast o no Texto abaixo do Switch
    setState(() {
      if (temaEscuro) {
        corTemaAtual = "Escuro";
        Fluttertoast.showToast(
            msg: "Alterado para o tema escuro",
            backgroundColor: Colors.white,
            textColor: Colors.black);
      } else {
        corTemaAtual = "Claro";
        Fluttertoast.showToast(
            msg: "Alterado para o tema claro",
            backgroundColor: Colors.black,
            textColor: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EscolheTema>(
        builder: (context, EscolheTema escolheTema, child) {
      escolheTemaGlobal = escolheTema;
      return Scaffold(
          appBar: AppBar(
            title: Text(escolheTema.temaEscuro ? "Tema escuro" : "Tema claro"),
            actions: [
              //Ícone da AppBar
              IconButton(
                  icon: Icon(escolheTema.temaEscuro
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  onPressed: () {
                    escolheTema.temaEscuro
                        ? escolheTema.temaEscuro = false
                        : escolheTema.temaEscuro = true;
                  })
            ],
          ),
          body: Column(children: [
            //Campos da tela
            Switch(value: temaEscuro, onChanged: alteraTema),
            Text('Tema $corTemaAtual')
          ]));
    });
  }
}
