public static class Haversine {
  public static double calculate(double lat1, double lon1, double lat2, double lon2) {
    var R = 6372.8; // In kilometers
    var dLat = toRadians(lat2 - lat1);
    var dLon = toRadians(lon2 - lon1);
    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);

    var a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) + Math.Sin(dLon / 2) * Math.Sin(dLon / 2) * Math.Cos(lat1) * Math.Cos(lat2);
    var c = 2 * Math.Asin(Math.Sqrt(a));
    return R * 2 * Math.Asin(Math.Sqrt(a));
  }

  public static double toRadians(double angle) {
    return Math.PI * angle / 180.0;
  }
}

void Main() {
  Console.WriteLine(String.Format("The distance between coordinates {0},{1} and {2},{3} is: {4}", 36.12, -86.67, 33.94, -118.40, Haversine.calculate(36.12, -86.67, 33.94, -118.40)));
}

// Returns: The distance between coordinates 36.12,-86.67 and 33.94,-118.4 is: 2887.25995060711
