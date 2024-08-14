import 'package:flutter/material.dart';
//Adicionar o pacote http para fazer requisição ao webservice API
//flutter pub add http
//Adicionar permissão para uso da internet
import 'package:http/http.dart' as http;
//Biblioteca do Dart para converter o Map para JSON
import 'dart:convert';
//Biblioteca adicionada para exibir mensagem Toast
import 'package:fluttertoast/fluttertoast.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => TelaCadastroState();
}

class TelaCadastroState extends State<TelaCadastro> {
  late String idFilme = "", idPessoa = "", nomePersonagem = "", idGenero = "";

  //Método para enviar dados ao webservice por meio de HTTP POST
  Future<void> cadastraPersonagem() async {
    //Mapear os valores que serão enviados
    Map dadosBody = {
      'idFilme': idFilme,
      'idPessoa': idPessoa,
      'nome': nomePersonagem,
      'idGenero': idGenero
    };
    //Converte o Map para JSON
    var body = json.encode(dadosBody);

    //Envia a requisição usando POST
    var resposta = await http.post(
        //URL
        Uri.parse(
            "http://www.douglasgaspar.com.br:21163/api/personagem/cadastrar"),
        headers: {"Content-Type": "application/json"},
        body: body);

    //Testa o código retornado pela API
    if (resposta.statusCode == 200) {
      //Código 200 indica sucesso
      Fluttertoast.showToast(msg: "Personagem cadastrada!");
    } else {
      //Caso contrário
      Fluttertoast.showToast(
          msg: 'Erro ao cadastrar! ${resposta.body}',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Configura tela com margem de 8 pixel
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //Layout de coluna
      child: Column(
        //Componentes que formarão a tela
        children: <Widget>[
          //Campo para o usuário digitar um valor
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ID do filme',
            ),
            //A cada alteração de digitação, atualiza o valor o idFilme
            onChanged: (value) {
              setState(() {
                idFilme = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ID da pessoa',
            ),
            //Atualiza o valor do idPessoa
            onChanged: (value) {
              setState(() {
                idPessoa = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nome do personagem',
            ),
            //Atualiza o valor do nomePersonagem
            onChanged: (value) {
              setState(() {
                nomePersonagem = value;
              });
            },
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ID do gênero',
            ),
            //Atualiza o valor do idGenero
            onChanged: (value) {
              setState(() {
                idGenero = value;
              });
            },
          ),
          //Botão para chamar o método cadastrarPersonagem
          ElevatedButton(
              onPressed: cadastraPersonagem,
              child: const Text("Cadastrar personagem"))
        ],
      ),
    );
  }
}
