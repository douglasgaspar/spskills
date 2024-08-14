//Classe utilizada para poder mapear o resultado da consulta na API
//e para listar na tela de listagem
class Produtoras {
  //Atributos da classe Produtoras
  int? idProdutora;
  String? nomeProdutora;

  //Construtor
  Produtoras({this.idProdutora, this.nomeProdutora});

  //Mapeando os atributos da classe com os atributos do JSON
  factory Produtoras.fromJson(Map<String, dynamic> json) {
    return Produtoras(
        idProdutora: json['company_id'], nomeProdutora: json['company_name']);
  }
}
