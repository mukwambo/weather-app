import 'dart:ui';
import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String hourlyTimeInterval, hourlyWeatherMeasurement;
  final IconData hourlyIcon;

  const HourlyForecastItem({
    super.key,
    required this.hourlyTimeInterval,
    required this.hourlyIcon,
    required this.hourlyWeatherMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    hourlyTimeInterval,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    hourlyIcon,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hourlyWeatherMeasurement,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
