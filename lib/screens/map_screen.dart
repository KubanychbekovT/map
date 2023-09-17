import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> terminalLocations = [];

  @override
  void initState() {
    super.initState();
    getLocation();
  }


  Future<void> loadTerminalData() async {
    // Здесь вы можете загрузить данные о терминалах из вашего источника данных
    // Пример загрузки данных:
    // final terminals = await loadTerminalsFromApi();
    // или
    // final terminals = await loadTerminalsFromFile();

    // Здесь создайте список координат терминалов из загруженных данных
    final List<LatLng> terminalLocations = [
      LatLng(53.711417, 91.431806), // Пример координат
      LatLng(51.716977,94.439535), // Пример координат
      LatLng(52.949807,36.021877), // Пример координат
      LatLng(59.900042,30.49042), // Пример координат
      LatLng(60.008577,30.252744), // Пример координат
      LatLng(37.394328643534, -92.826065500099), // Пример координат
      LatLng(44.386308916800, -104.617262302026), // Пример координат
      LatLng(25.386328830079, -106.725974116525), // Пример координат
      LatLng(27.386338818773, -80.774672219595), // Пример координат
      LatLng(39.395358181818, -74.475062075227), // Пример координат
      // Добавьте сюда координаты других терминалов
    ];

    setState(() {
      this.terminalLocations = terminalLocations;
    });
  }


  Future<void> getLocation() async {
    final location = Location();
    try {
      final locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
      mapController.move(
        LatLng(locationData.latitude!, locationData.longitude!),
        13.0,
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _showMyLocation() {
    if (currentLocation != null) {
      mapController.move(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        13.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Моя карта'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: _showMyLocation,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: currentLocation != null
              ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
              : LatLng(0, 0),
          zoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (currentLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(
                    currentLocation!.latitude!,
                    currentLocation!.longitude!,
                  ),
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          MarkerLayer(
            markers: terminalLocations
                .map(
                  (location) => Marker(
                    width: 40.0,
                    height: 40.0,
                    point: location,
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadTerminalData,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
