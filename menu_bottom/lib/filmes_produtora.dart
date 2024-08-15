//Classe utilizada para listar os filmes de uma produtora

class FilmesProdutora {
  String? tituloFilme;
  int? filmeID;

  //Construtor
  FilmesProdutora({this.tituloFilme, this.filmeID});

  //Conversão do JSON para objeto
  factory FilmesProdutora.fromJson(Map<String, dynamic> json) {
    return FilmesProdutora(
        tituloFilme: json['title'], filmeID: json['movie_id']);
  }
}
