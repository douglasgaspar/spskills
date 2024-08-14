import 'package:flutter/material.dart';
import 'package:menu_bottom/tela_cadastro.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu inferior',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TelaMenuInferior(title: 'Menu inferior'),
    );
  }
}

class TelaMenuInferior extends StatefulWidget {
  const TelaMenuInferior({super.key, required this.title});
  final String title;

  @override
  State<TelaMenuInferior> createState() => _TelaMenuInferiorState();
}

class _TelaMenuInferiorState extends State<TelaMenuInferior> {
  //Variável para controlar qual item (índice) do menu é selecionado
  int indiceMenu = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            //Monta os itens que estarão no menu
            NavigationDestination(icon: Icon(Icons.home), label: "Início"),
            NavigationDestination(icon: Icon(Icons.add), label: "Cadastrar"),
            NavigationDestination(icon: Icon(Icons.list), label: "Listar"),
          ],
          selectedIndex: indiceMenu, //Marca o item selecionado
          indicatorColor: Colors.cyan,
          onDestinationSelected: (indice) {
            //Atualiza o índice ao clicar no menu
            setState(() {
              indiceMenu = indice;
            });
          },
        ),
        body: <Widget>[
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Tela inicial',
                ),
              ],
            ),
          ),
          //Conteúdo do segundo item do menu inferior
          const TelaCadastro(),
        ][indiceMenu]);
  }
}
