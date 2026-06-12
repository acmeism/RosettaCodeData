public class Main {
    public static String toWord(long w) {
        return String.format("W%05d", w);
    }

    public static long fromWord(String ws) {
        return Long.parseLong(ws.substring(1));
    }

    public static void main(String[] args) {
        System.out.println("Starting figures:");
        double lat = 28.3852;
        double lon = -81.5638;
        System.out.printf("  latitude = %.4f, longitude = %.4f%n", lat, lon);

        // Convert lat and lon to positive integers
        long ilat = (long)(lat * 10000 + 900000);
        long ilon = (long)(lon * 10000 + 1800000);

        // Build 43-bit long comprising 21 bits (lat) and 22 bits (lon)
        long latlon = (ilat << 22) + ilon;

        // Isolate relevant bits
        long w1 = (latlon >> 28) & 0x7fff;
        long w2 = (latlon >> 14) & 0x3fff;
        long w3 = latlon & 0x3fff;

        // Convert to word format
        String w1s = toWord(w1);
        String w2s = toWord(w2);
        String w3s = toWord(w3);

        // Print the results
        System.out.println("\nThree word location is:");
        System.out.printf("  %s %s %s%n", w1s, w2s, w3s);

        // Reverse the procedure
        w1 = fromWord(w1s);
        w2 = fromWord(w2s);
        w3 = fromWord(w3s);

        latlon = (w1 << 28) | (w2 << 14) | w3;
        ilat = latlon >> 22;
        ilon = latlon & 0x3fffff;

        lat = (ilat - 900000) / 10000.0;
        lon = (ilon - 1800000) / 10000.0;

        // Print the results
        System.out.println("\nAfter reversing the procedure:");
        System.out.printf("  latitude = %.4f, longitude = %.4f%n", lat, lon);
    }
}

