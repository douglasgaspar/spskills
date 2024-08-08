//Alterar o arquivo AndroidManifest e adicionar as permissões para uso do GPS
//<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
//<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//Alterar o arquivo AndroidManifest e adicionar a API_KEY do Google Maps
//<meta-data android:name="com.google.android.geo.API_KEY" android:value="""

import 'package:flutter/material.dart';
//Biblioteca do Google Maps importada no projeto
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  static const LatLng _center = LatLng(-22.91505, -47.055931);

  //Objeto para posicionar o mapa na Escola SENAI Zerbini
  static const CameraPosition latLongZerbini = CameraPosition(
      bearing: 92.8334901395799, //Posição da bússola
      target: _center,
      tilt: 10.440717697143555, //Inclinação da câmera
      zoom: 19.151926040649414);

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
  }

  //Conteúdo visual da tela que terá o Google Maps
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa e GPS'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: latLongZerbini,
        ),
      ),
    );
  }
}
