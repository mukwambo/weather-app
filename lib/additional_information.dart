import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData weatherIcon;
  final String weatherLabel, weatherMeasurement;

  const AdditionalInformation({
    super.key,
    required this.weatherIcon,
    required this.weatherLabel,
    required this.weatherMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          weatherIcon,
          size: 50,
        ),
        const SizedBox(height: 8),
        Text(
          weatherLabel,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          weatherMeasurement,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
