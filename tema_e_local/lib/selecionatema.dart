import 'package:flutter/material.dart';
import 'salvarLocal.dart';

class EscolheTema extends ChangeNotifier {
  //Late para indicar que o valor do campo será atribuído depois
  late bool _temaEscuro;
  //Objeto da classe SalvarLocal
  late SalvarLocal sharedPref;
  //Método get para recuperar o valor do tema (claro ou escuro)
  bool get temaEscuro => _temaEscuro;

  //Construtor da classe
  EscolheTema() {
    //Começa com o tema claro
    _temaEscuro = false;
    //Inicia o objeto da classe SalvarLocal
    sharedPref = SalvarLocal();
    //Chama o método que irá ler o sharePreferences e ver qual o último tema salvo
    getPreferences();
  }

  //Método set para atribuir o valor do tema escolhido
  set temaEscuro(bool valorTema) {
    _temaEscuro = valorTema; //Se é tema escuro ou não
    sharedPref.gravarValor(valorTema); //Grava o valor escolhido
    notifyListeners(); //Notifica e atualiza a tela
  }

  getPreferences() async {
    //Verifica qual o valor do tema salvo
    _temaEscuro = await sharedPref.recuperaValor();
    notifyListeners(); //Notifica e atualiza a tela
  }
}
