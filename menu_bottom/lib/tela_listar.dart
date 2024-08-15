import 'package:flutter/material.dart';
import 'package:menu_bottom/filmes_produtora.dart';
import 'package:menu_bottom/produtoras.dart';
import 'dart:convert';
//Adicionar permissão para uso da internet
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class TelaListar extends StatefulWidget {
  const TelaListar({super.key});

  @override
  State<TelaListar> createState() => _TelaListarState();
}

class _TelaListarState extends State<TelaListar> {
  //Lista que será preenchida com o resultado da consulta da API
  List<Produtoras> produtorasLista = [];
  //Objeto para recuperar o item selecionado no DropDown
  Produtoras? produtoraSelecionada;
  //Lista de FilmesProdutora para armazenar o título dos filmes da produtora selecionada
  List<FilmesProdutora> tituloFilmes = [];
  //Variável para armazenar o ID do filme a ser removido
  int filmeID = 0;
  String tituloFilmeAlert = "";
  bool filmeRemovido = false;

  //Método para consultar o nome das produtoras
  Future<List<Produtoras>> buscarProdutoras() async {
    //Realizar a consulta no webservice usando GET
    final resposta = await http.get(Uri.parse(
        'http://www.douglasgaspar.com.br:21163/api/produtoras/listar100'));

    //Se obter resultado com sucesso
    if (resposta.statusCode == 200) {
      //Atualiza o conteúdo da lista "produtorasLista"
      setState(() {
        //Converte o resultado do JSON para uma List
        //Recupera cada objeto do Array e faz um map usando o método
        //fromJson da classe Produtoras
        produtorasLista = List<Produtoras>.from(
            json.decode(resposta.body).map((x) => Produtoras.fromJson(x)));
      });
      return produtorasLista;
    } else {
      //Se encontrar erro exibe mensagem
      Fluttertoast.showToast(
          msg: 'Erro ao buscar dados! ${resposta.body}',
          backgroundColor: Colors.red);
      throw Exception();
    }
  }

  //Método para buscar o título dos filmes de uma produtora selecionada no DropDown
  Future<List<FilmesProdutora>> buscarFilmes() async {
    //Realizar a consulta no webservice usando GET
    final resposta = await http.get(Uri.parse(
        'http://www.douglasgaspar.com.br:21163/api/produtoras/filmes/listar/${produtoraSelecionada!.idProdutora}'));

    //Verificar o status do retorno
    if (resposta.statusCode == 200) {
      //Atualiza a lista com os títulos
      setState(() {
        //Converte a resposta para o padrão da classe FilmesProdutora
        tituloFilmes = List<FilmesProdutora>.from(
            json.decode(resposta.body).map((x) => FilmesProdutora.fromJson(x)));
      });
      return tituloFilmes;
    } else {
      //Se encontrar erro exibe mensagem
      Fluttertoast.showToast(
          msg: 'Erro ao buscar filmes da produtora! ${resposta.body}',
          backgroundColor: Colors.red);
      throw Exception();
    }
  }

  //Método para buscar o título dos filmes de uma produtora selecionada no DropDown
  Future<bool> removerFilme(int index) async {
    //Realizar o envio da requisição no webservice usando DELETE
    final resposta = await http.delete(Uri.parse(
        'http://www.douglasgaspar.com.br:21163/api/filmes/apagar/$filmeID'));

    //Verificar o status do retorno
    if (resposta.statusCode == 200) {
      setState(() {
        filmeRemovido = true;
        tituloFilmes.removeAt(index);
      });
      return true;
    } else {
      //Se encontrar erro exibe mensagem
      Fluttertoast.showToast(
          msg: 'Erro ao buscar filmes da produtora! ${resposta.body}',
          backgroundColor: Colors.red);
      setState(() {
        filmeRemovido = false;
      });
      return false;
    }
  }

  Future<void> criaAlertDialog(BuildContext context, int index) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Apagar filme?"),
            content: Text('Deseja mesmo apagar o filme $tituloFilmeAlert'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await removerFilme(index);
                    if (filmeRemovido) {
                      Fluttertoast.showToast(msg: "Filme removido");
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Sim")),
              TextButton(
                  onPressed: () {
                    //Fecha o dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    //Ao iniciar a tela busca o nome das produtoras
    buscarProdutoras();
  }

  @override
  Widget build(BuildContext context) {
    //Conteúdo da tela
    return Padding(
        padding: const EdgeInsets.all(8.0),
        //Se a lista de produtoras estiver vazia...
        child: produtorasLista.isEmpty
            ? const Center(
                //... exibe a barra circular de progesso
                child: CircularProgressIndicator(),
              )
            //... caso contrário, exibe o conteúdo da tela que é
            //um campo de Texto, um DropDown e o ListView
            : Column(children: <Widget>[
                //Campo de texto
                const Text("Selecione uma produtora"),
                //Configuração do DropDown
                DropdownMenu<Produtoras>(
                  //Selecionar o primeiro item da lista
                  initialSelection: produtorasLista.first,
                  //Conteúdo de itens do DropDown
                  dropdownMenuEntries: produtorasLista
                      //Percorre cada item da lista
                      .map<DropdownMenuEntry<Produtoras>>((Produtoras prod) {
                    //Retorna um DropDownMenuEntry para cada item da lista
                    return DropdownMenuEntry<Produtoras>(
                        //Cada item da lista é configurado com o objeto da Produtora
                        //O nome de exibição (label) é o nome da produtora
                        value: prod,
                        label: prod.nomeProdutora!);
                  }).toList(),
                  //Sempre que selecionar um item do DropDown...
                  onSelected: (value) {
                    setState(() {
                      //Atualiza o objeto da produtoraSelecionada
                      produtoraSelecionada = value;
                      //Faz a chamada dos filmes para a produtora selecionada
                      buscarFilmes();
                    });
                  },
                ),
                //A parte abaixo do DropDown é um ListView
                //Para poder encaixar na tela foi utilizado o layout do Exapanded
                //caso contrário o ListView extrapola o tamanho da tela e não exibe
                Expanded(
                    child: ListView.builder(
                  //Configuração do ListView
                  itemCount: tituloFilmes.length, //Quantidade de itens
                  itemBuilder: (context, index) {
                    //Conteúdo e configuração de cada item
                    return Card(
                        //Cor de fundo
                        color: Colors.amber,
                        child: Column(children: [
                          //Cria uma linha para cada item com o título do filme
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    tituloFilmes[index].tituloFilme.toString()),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        filmeID = tituloFilmes[index].filmeID!;
                                        tituloFilmeAlert =
                                            tituloFilmes[index].tituloFilme!;
                                      });
                                      criaAlertDialog(context, index);
                                      Fluttertoast.showToast(
                                          msg: 'Filme ID $filmeID');
                                    },
                                    icon: const Icon(Icons.delete),
                                    label: const Text("Apagar"))
                              ])
                        ]));
                  },
                )),
              ]));
  }
}
