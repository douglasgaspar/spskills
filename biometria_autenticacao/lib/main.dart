//Alterar o arquivo android/app/src/main/kotlin/com/example/[your.package]/MainActivity.kt
//para que a tela inicial seja um Fragment e não uma Activity
//Adicionar permissão no arquivo Manifest.

//Adicionar a biblioteca de autenticação - local_auth
//flutter pub add local_auth
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
//Biblioteca usada no try/catch
import 'package:flutter/services.dart';
//Biblioteca para fazer exibição do Toast
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometria e autenticação',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Biometria e autenticação'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Objeto para verificar as condições de biometria do dispositivo
  final LocalAuthentication autenticacao = LocalAuthentication();
  //Variável para armazenar o resultado se o dispositivo tem recursos de biometria
  bool possuiBiometria = false;
  //Lista para armazenar os tipos de biometria que o dispositivo possui
  List<BiometricType> listaBiometrias = [];
  //Variável para armazenar o resultado da leitura da biometria
  bool autorizadoAcesso = false;

  Future<void> verificaTipoBiometria() async {
    listaBiometrias = await autenticacao.getAvailableBiometrics();
  }

  Future<void> autentica() async {
    try {
      autorizadoAcesso = await autenticacao.authenticate(
        localizedReason:
            'Faça a leitura da sua impressão digital para validar o acesso.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      Fluttertoast.showToast(
          msg: 'Autorizado? ${autorizadoAcesso == true ? ' Sim ' : ' Não'} ');
    } on PlatformException catch (exc) {
      print(exc);
      Fluttertoast.showToast(msg: "Erro ao fazer leitura");
    }
  }

  //Método executado ao iniciar a verificação de estado
  @override
  void initState() {
    super.initState();
    //Verificar quais as biometrias disponíveis no dispositivo
    //Como o método isDeviceSupported retorna um objeto do tipo Future
    //então devemos esperar a sua execução para saber qual foi seu resultado
    //Podemos fazer isso chamando o método then() na sequência
    autenticacao.isDeviceSupported().then((valor) => setState(() {
          //Atualiza o valor da variável "possuiBiometria" de acordo com o resultado
          possuiBiometria = valor;
        }));

    //Recupera o valor dos tipos de biometrias disponíveis
    autenticacao.getAvailableBiometrics().then((lista) => setState(() {
          listaBiometrias = lista;
          print(listaBiometrias);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (possuiBiometria)
              const Text(
                'Pressione o botão abaixo para validar a biometria',
              )
            else
              const Text(
                'Dispositivo sem suporte a biometria.',
              ),
            ElevatedButton(
                onPressed: () {
                  if (possuiBiometria) {
                    autentica();
                  } else {
                    Fluttertoast.showToast(
                        msg: "O dispositivo não possui recursos de biometria");
                  }
                },
                child: const Text("Validar biometria")),
          ],
        ),
      ),
    );
  }
}
