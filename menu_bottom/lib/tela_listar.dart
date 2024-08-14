import 'package:flutter/material.dart';
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
  List<Produtoras>? produtorasLista = [];

  //Método para consultar o nome das produtoras
  Future<List<Produtoras>> buscarProdutoras() async {
    //Realizar a consulta no webservice usando GET
    final resposta = await http.get(Uri.parse(
        'http://www.douglasgaspar.com.br:21163/api/produtoras/listar'));

    //Se obter resultado com sucesso
    if (resposta.statusCode == 200) {
      //Atualiza o conteúdo da lista "produtorasLista"
      setState(() {
        //Converte o resultado do JSON para uma List
        produtorasLista = List<Produtoras>.from(
            json.decode(resposta.body).map((x) => Produtoras.fromJson(x)));
      });
      return produtorasLista!;
    } else {
      //Se encontrar erro exibe mensagem
      Fluttertoast.showToast(
          msg: 'Erro ao buscar dados! ${resposta.body}',
          backgroundColor: Colors.red);
      throw Exception();
    }
  }

  @override
  void initState() {
    super.initState();
    buscarProdutoras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tela listar'),
        ),
        body: produtorasLista!.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: produtorasLista?.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(produtorasLista![index].idProdutora.toString()),
                          Text(
                              produtorasLista![index].nomeProdutora.toString()),
                        ],
                      ),
                    ]),
                  );
                }));
  }
}
