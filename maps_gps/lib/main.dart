//Alterar o arquivo AndroidManifest e adicionar as permissões para uso do GPS
//<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
//<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//Alterar o arquivo AndroidManifest e adicionar a API_KEY do Google Maps
//<meta-data android:name="com.google.android.geo.API_KEY" android:value="""

//Biblioteca utilizada para recuperar as atualizações do GPS
import 'dart:async';
//Biblioteca padrão dos componentes Material Design
import 'package:flutter/material.dart';
//Biblioteca do Google Maps importada no projeto
import 'package:google_maps_flutter/google_maps_flutter.dart';
//Biblioteca para recuperar permissão e dados de localização
import 'package:geolocator/geolocator.dart';
//Biblioteca para exibição de mensagens via Toast
import 'package:fluttertoast/fluttertoast.dart';

//Ponto de partida da aplicação
void main() {
  runApp(const MyApp());
}

//Classe do app principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Código padrão do projeto inicial
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa e GPS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 206, 194, 228)),
        useMaterial3: true,
      ),
      home: const MapaGPS(), //Indica o que será aberto na tela inicial
    );
  }
}

//Criando uma classe Stateful para controlar o Widget do Google Maps
class MapaGPS extends StatefulWidget {
  const MapaGPS({super.key});

  //Indica a classe que será responsável por controlar o estado
  @override
  State<MapaGPS> createState() => _MapaGPSState();
}

//Cria a classe que controla o estado
class _MapaGPSState extends State<MapaGPS> {
  //Objeto que irá receber a referência para o Google Maps da tela
  late GoogleMapController mapController;
  //Localização da escola SENAI Zerbini
  static const LatLng senaiZerbini = LatLng(-22.91505, -47.055931);
  //static const LatLng campinasCentro = LatLng(-22.9064, -47.0616);
  //Objeto para armazenar a posição atual
  Position? posicaoAtual;

  var marcadorAtual = const Marker(markerId: MarkerId('Seu local atual'));

  //Objeto para posicionar o mapa na Escola SENAI Zerbini
  static const CameraPosition posicaoCamera = CameraPosition(
      bearing: 92.8334901395799, //Posição da bússola
      target: senaiZerbini, //Local
      tilt: 10.440717697143555, //Inclinação da câmera
      zoom: 19.151926040649414);

  //Método para gerenciar as permissões de GPS
  Future<bool> verificaPermissao() async {
    //Armazena se o GPS está ligado ou não
    bool gpsLigado;
    //Armazena o resultado da escolha do usuário quanto a permissão
    LocationPermission estadoPermissao;

    //Recupera a situação se o GPS está ligado ou não
    gpsLigado = await Geolocator.isLocationServiceEnabled();
    if (!gpsLigado) {
      //Se o GPS não estiver ligado
      Fluttertoast.showToast(
          msg: "Localiação desligada. Ligue para utilizar o aplicativo");
      return false; //Encerra o método
    }

    //Verifica qual a opção o usuário escolheu com relação a permissão de uso da localização
    estadoPermissao = await Geolocator.checkPermission();
    //Se escolheu negar
    if (estadoPermissao == LocationPermission.denied) {
      //Requisita novamente
      estadoPermissao = await Geolocator.requestPermission();
      //Se continuar negando, exibe mensagem
      if (estadoPermissao == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg:
                "O acesso a localização foi negado. Por favor, autorize para utilizar o aplicativo");
        return false; //Encerra
      }
    }
    //Se escolheu negar sempre
    if (estadoPermissao == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              "O acesso a localização foi negado. Autorize para utilizar o aplicativo");
      return false; //Encerra
    }
    //Se autorizou retorna verdadeiro
    return true;
  }

  //Método para recuperar a posição de GPS e localização do dispositivo
  Future<void> recuperaLocalizacaoAtual() async {
    //Verifica se o usuário deu permissão de acesso à localização
    final permitiuGPS = await verificaPermissao();
    if (!permitiuGPS) return; //Se não permitiu, cancela

    //Configuração de precisão da localização
    const LocationSettings configPrecisao = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, //Atualiza a cada mudança de ao menos 10 metros
    );

    //Método que será sempre chamado a cada mudança de localização
    StreamSubscription<Position> resultadoLocal =
        Geolocator.getPositionStream(locationSettings: configPrecisao)
            .listen((posicaoRecuperada) {
      //Atualiza o estado da variável posicaoAtual a cada mudança de posição
      setState(() {
        //Atualiza o valor da posição atual
        posicaoAtual = posicaoRecuperada;
        //Atualiza o valor do marcador
        marcadorAtual = Marker(
            markerId: const MarkerId('Seu local atual'),
            infoWindow: InfoWindow(
              title: "Seu local atual",
              snippet:
                  "Latitude  ${posicaoAtual?.latitude} Longitude ${posicaoAtual?.longitude} ",
            ),
            position: LatLng(
                posicaoRecuperada.latitude, posicaoRecuperada.longitude));
      });
    });
  }

  //Método assíncrono que será executado quando o maps estiver pronto
  Future<void> onMapCreated(GoogleMapController controller) async {
    //Atribui o objeto do Google Maps para o objeto da classe
    mapController = controller;
  }

  //Controle de fluxo
  //Ao iniciar o aplicativo verificar as permissões e localização do GPS
  @override
  void initState() {
    super.initState();
    verificaPermissao();
    recuperaLocalizacaoAtual();
  }

  @override

  //Conteúdo visual da tela que terá o Google Maps
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Mapa e localização"),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: posicaoCamera,
          markers: {marcadorAtual},
        ),
      ),
    );
  }
}
