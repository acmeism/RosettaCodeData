import std.stdio, std.file, std.csv, std.range, std.math, std.conv, std.algorithm;

struct GeoPos {
    float lat;
    float lon;

    static auto sind = (float x) => sin(x * PI / 180);
    static auto cosd = (float x) => cos(x * PI / 180);

    float distanceTo(GeoPos other) {
        float a = pow(sind((other.lat - lat) / 2), 2)
                + cosd(lat) * cosd(other.lat) * pow(sind((other.lon - lon) / 2), 2);
        float r = 6372.8 / 1.852;
        return 2 * r * asin(sqrt(a));
    }

    float bearingTo(GeoPos other) {
        float theta = atan2(sind(other.lon - lon) * cosd(other.lat),
            cosd(lat) * sind(other.lat) - sind(lat) * cosd(other.lat) * cosd(other.lon - lon));
        return fmod(theta / (PI / 180.0) + 360.0, 360.0);
    }
}

struct Airport {
    string name;
    string country;
    string ICAO;
    float  distance;
    float  bearing;

    this(string[] cols, GeoPos refPos) {
        name    = cols[1];
        country = cols[3];
        ICAO    = cols[5];
        GeoPos pos = GeoPos(cols[6].to!float, cols[7].to!float);
        distance = refPos.distanceTo(pos);
        bearing = refPos.bearingTo(pos);
    }
}

void main() {
    GeoPos refPos = GeoPos(51.514669, 2.198581);

    auto airports = readText("airports.dat")
        .csvReader
        .map!(a => Airport(a.array, refPos)).array
        .schwartzSort!"a.distance"
        .take(20);

    writeln("Airport                              Country         ICAO  Distance  Bearing");
    writeln("----------------------------------------------------------------------------");
    foreach (Airport a; airports)
        writefln("%-36s %-15s %-8s%.1f %8.0f", a.name, a.country, a.ICAO, a.distance, a.bearing);
}
