//Classe utilizada para listar os filmes de uma produtora

class FilmesProdutora {
  String? tituloFilme;

  //Construtor
  FilmesProdutora({this.tituloFilme});

  //Conversão do JSON para objeto
  factory FilmesProdutora.fromJson(Map<String, dynamic> json) {
    return FilmesProdutora(tituloFilme: json['title']);
  }
}
