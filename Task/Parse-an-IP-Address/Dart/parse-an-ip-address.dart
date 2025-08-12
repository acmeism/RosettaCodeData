import 'dart:io';

class ParseIPAddress {
  static final RegExp _ipv4Pat = RegExp(r'^(\d+)\.(\d+)\.(\d+)\.(\d+)(?::(\d+))?$');
  static final RegExp _ipv6DoubleColPat = RegExp(r'^\[?([0-9a-f:]*)::([0-9a-f:]*)(?:\]:(\d+))?$');
  static late final RegExp _ipv6Pat;

  static void _initializeIPv6Pattern() {
    String ipv6Pattern = r'^\[?';
    for (int i = 1; i <= 7; i++) {
      ipv6Pattern += r'([0-9a-f]+):';
    }
    ipv6Pattern += r'([0-9a-f]+)(?:\]:(\d+))?$';
    _ipv6Pat = RegExp(ipv6Pattern);
  }

  static void main() {
    // Initialize the IPv6 pattern
    _initializeIPv6Pattern();

    List<String> tests = [
      "192.168.0.1",
      "127.0.0.1",
      "256.0.0.1",
      "127.0.0.1:80",
      "::1",
      "[::1]:80",
      "[32e::12f]:80",
      "2605:2700:0:3::4713:93e3",
      "[2605:2700:0:3::4713:93e3]:80",
      "2001:db8:85a3:0:0:8a2e:370:7334"
    ];

    print('${'Test Case'.padRight(40)} ${'Hex Address'.padRight(32)}   Port');

    for (String ip in tests) {
      try {
        List<String> parsed = _parseIP(ip);
        print('${ip.padRight(40)} ${parsed[0].padRight(32)}   ${parsed[1]}');
      } catch (e) {
        print('${ip.padRight(40)} Invalid address:  ${e.toString()}');
      }
    }
  }

  static List<String> _parseIP(String ip) {
    String hex = "";
    String port = "";

    // IPv4
    RegExpMatch? ipv4Match = _ipv4Pat.firstMatch(ip);
    if (ipv4Match != null) {
      for (int i = 1; i <= 4; i++) {
        hex += _toHex4(ipv4Match.group(i)!);
      }
      if (ipv4Match.group(5) != null) {
        port = ipv4Match.group(5)!;
      }
      return [hex, port];
    }

    // IPv6, double colon
    RegExpMatch? ipv6DoubleColonMatch = _ipv6DoubleColPat.firstMatch(ip);
    if (ipv6DoubleColonMatch != null) {
      String p1 = ipv6DoubleColonMatch.group(1) ?? "";
      if (p1.isEmpty) {
        p1 = "0";
      }
      String p2 = ipv6DoubleColonMatch.group(2) ?? "";
      if (p2.isEmpty) {
        p2 = "0";
      }
      ip = p1 + _getZero(8 - _numCount(p1) - _numCount(p2)) + p2;
      if (ipv6DoubleColonMatch.group(3) != null) {
        ip = "[$ip]:${ipv6DoubleColonMatch.group(3)}";
      }
    }

    // IPv6
    RegExpMatch? ipv6Match = _ipv6Pat.firstMatch(ip);
    if (ipv6Match != null) {
      for (int i = 1; i <= 8; i++) {
        String hexPart = _toHex6(ipv6Match.group(i)!);
        hex += hexPart.padLeft(4, '0');
      }
      if (ipv6Match.group(9) != null) {
        port = ipv6Match.group(9)!;
      }
      return [hex, port];
    }

    throw ArgumentError("ERROR 103: Unknown address: $ip");
  }

  static int _numCount(String s) {
    return s.split(':').length;
  }

  static String _getZero(int count) {
    StringBuffer sb = StringBuffer();
    sb.write(":");
    while (count > 0) {
      sb.write("0:");
      count--;
    }
    return sb.toString();
  }

  static String _toHex4(String s) {
    int val = int.parse(s);
    if (val < 0 || val > 255) {
      throw ArgumentError("ERROR 101: Invalid value: $s");
    }
    return val.toRadixString(16).toUpperCase().padLeft(2, '0');
  }

  static String _toHex6(String s) {
    int val = int.parse(s, radix: 16);
    if (val < 0 || val > 65536) {
      throw ArgumentError("ERROR 102: Invalid hex value: $s");
    }
    return s;
  }
}

void main() {
  ParseIPAddress.main();
}
