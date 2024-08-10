//Biblioteca para armazenamento local usando padrão do SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

//Criação da classe
class SalvarLocal {
  //Criação dos métodos da classe
  //Método para gravar um valor no campo "temaEscuro"
  gravarValor(bool valor) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("temaEscuro", valor);
  }

  //Método para recuperar um valor do campo "temaEscuro"
  recuperaValor() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool("temaEscuro") ?? false;
  }
}
