//Alterar a versãominSdkVersion para 21 ou acima
import 'dart:async';
//Adicionar a biblioteca para recuperar o caminho do arquivo - flutter pub add path path_provider
//Adicionar a biblioteca da câmera - flutter pub add camera
import 'package:camera/camera.dart';
//Classe para recuperar o contexto da aplicação fora de um widget
import 'package:camera_galeria/navegacao_contexto.dart';
//Importando a tela que irá exibir a foto tirada
import 'package:camera_galeria/tela_foto.dart';
import 'package:flutter/material.dart';

late CameraDescription cameraPrincipal;

void main() async {
  //Adicionado o async por causa da chamada await
  //Verificar se o serviço de plugins está habilitado
  WidgetsFlutterBinding.ensureInitialized();
  //Recuperar a lista das câmeras disponíveis no dispositivo
  final cameras = await availableCameras();
  //Indicar qual câmera será utilizada
  cameraPrincipal = cameras.first;

  //Abrir a tela principal e indicar qual câmera será utilizada
  runApp(MyApp(camera: cameraPrincipal));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: ContextService.chaveContextoGlobal,
      title: 'Câmera e galeria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Câmera e galeria',
        camera: cameraPrincipal,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.camera});

  final String title;
  //Indicação de qual câmera foi escolhida para tirar a foto
  final CameraDescription camera;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Objeto para controlar as ações da câmera
  late CameraController controllerCamera;
  //Objeto Future para armazenar o retorno da câmera assim que ela for iniciado
  late Future<void> conteudoCameraIniciado;

  @override
  void initState() {
    super.initState();
    //Iniciar o objeto do CameraController
    controllerCamera = CameraController(widget.camera, ResolutionPreset.medium);
    //Iniciar o conteúdo de captura da câmera
    conteudoCameraIniciado = controllerCamera.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    //Fechar a câmera quando encerrar a tela
    controllerCamera.dispose();
  }

  Future<void> tirarFoto() async {
    //Verifica se a câmera foi iniciada
    await conteudoCameraIniciado;

    //Tira a foto com o método takePicture
    final imagemFoto = await controllerCamera.takePicture();
    //Testa se o contexto foi iniciado
    if (!ContextService.chaveContextoGlobal.currentContext!.mounted) {
      return;
    }
    //Se o contexto estiver correto então abre a tela para visualizar a imagem
    await Navigator.of(ContextService.chaveContextoGlobal.currentContext!).push(
      MaterialPageRoute(
        //Abre a tela e passa o caminho da foto que está na memória
        builder: (context) => TelaFoto(arquivo: imagemFoto.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      //O conteúdo da tela será o retorno da câmera
      body: FutureBuilder<void>(
        future: conteudoCameraIniciado,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //CameraPreview é um widget aonde o conteúdo da câmera será exibido
            return CameraPreview(controllerCamera);
          } else {
            //Caso a câmera apresente algum problema, exibe mensagem
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text("Não foi possível abrir a câmera")],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: tirarFoto,
        tooltip: 'Tirar foto',
        child: const Icon(Icons.camera),
      ),
    );
  }
}
