import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/secrets.dart';
import 'additional_information.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  // This function gets realtime weather through an api
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Nairobi";
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,kenya&APPID=$openWeatherAPIKey'),
      );

      final data = jsonDecode(result.body);

      /* check whether the 'cod' value is 200, a cod value of 200 means that the API request is
      * a success otherwise the cod value will be 401 to mean the request is unsuccessful
      * just like 404 for unfound page.
      */

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred!';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemperature = currentWeatherData['main']['temp'];
          final currentWeather = currentWeatherData['weather'][0]['main'];
          final weatherDescription =
              currentWeatherData['weather'][0]['description'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemperature K",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentWeather == 'Clouds'
                                    ? Icons.cloud
                                    : currentWeather == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "$weatherDescription",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTimeInterval =
                          DateTime.parse(hourlyForecast['dt_txt']);

                      return HourlyForecastItem(
                          hourlyTimeInterval:
                              DateFormat.j().format(hourlyTimeInterval),
                          hourlyIcon: hourlySky == 'Clouds'
                              ? Icons.cloud
                              : hourlySky == 'Rain'
                                  ? Icons.cloudy_snowing
                                  : Icons.sunny,
                          hourlyWeatherMeasurement:
                              '${hourlyForecast['main']['temp']}');
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Additional information
                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                      weatherIcon: Icons.water_drop,
                      weatherLabel: "Humidity",
                      weatherMeasurement: "$currentHumidity",
                    ),
                    AdditionalInformation(
                      weatherIcon: Icons.air,
                      weatherLabel: "Wind Speed",
                      weatherMeasurement: "$currentWindSpeed",
                    ),
                    AdditionalInformation(
                      weatherIcon: Icons.beach_access,
                      weatherLabel: "Pressure",
                      weatherMeasurement: "$currentPressure",
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
