double kelvinToCelsius(double k) {
  return k - 273.15;
}

double kelvinToFahrenheit(double k) {
  return k * 1.8 - 459.67;
}

double kelvinToRankine(double k) {
  return k * 1.8;
}

void convertKelvin(double kelvin) {
  print('K = ${kelvin.toStringAsFixed(2)}');
  print('C = ${kelvinToCelsius(kelvin).toStringAsFixed(2)}');
  print('F = ${kelvinToFahrenheit(kelvin).toStringAsFixed(2)}');
  print('R = ${kelvinToRankine(kelvin).toStringAsFixed(2)}');
  print('');
}

void main() {
  convertKelvin(0.0);
  convertKelvin(21.0);
}
