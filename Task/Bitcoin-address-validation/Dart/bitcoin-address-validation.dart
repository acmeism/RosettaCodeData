import 'package:crypto/crypto.dart';

class Bitcoin {
  final String ALPHABET =
      "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

  List<int> bigIntToByteArray(BigInt data) {
    String str;
    bool neg = false;
    if (data < BigInt.zero) {
      str = (~data).toRadixString(16);
      neg = true;
    } else str = data.toRadixString(16);
    int p = 0;
    int len = str.length;

    int blen = (len + 1) ~/ 2;
    int boff = 0;
    List bytes;
    if (neg) {
      if (len & 1 == 1) {
        p = -1;
      }
      int byte0 = ~int.parse(str.substring(0, p + 2), radix: 16);
      if (byte0 < -128) byte0 += 256;
      if (byte0 >= 0) {
        boff = 1;
        bytes = new List<int>(blen + 1);
        bytes[0] = -1;
        bytes[1] = byte0;
      } else {
        bytes = new List<int>(blen);
        bytes[0] = byte0;
      }
      for (int i = 1; i < blen; ++i) {
        int byte = ~int.parse(str.substring(p + (i << 1), p + (i << 1) + 2),
            radix: 16);
        if (byte < -128) byte += 256;
        bytes[i + boff] = byte;
      }
    } else {
      if (len & 1 == 1) {
        p = -1;
      }
      int byte0 = int.parse(str.substring(0, p + 2), radix: 16);
      if (byte0 > 127) byte0 -= 256;
      if (byte0 < 0) {
        boff = 1;
        bytes = new List<int>(blen + 1);
        bytes[0] = 0;
        bytes[1] = byte0;
      } else {
        bytes = new List<int>(blen);
        bytes[0] = byte0;
      }
      for (int i = 1; i < blen; ++i) {
        int byte =
            int.parse(str.substring(p + (i << 1), p + (i << 1) + 2), radix: 16);
        if (byte > 127) byte -= 256;
        bytes[i + boff] = byte;
      }
    }
    return bytes;
  }

  List<int> arrayCopy(bytes, srcOffset, result, destOffset, bytesLength) {
    for (int i = srcOffset; i < bytesLength; i++) {
      result[destOffset + i] = bytes[i];
    }
    return result;
  }

  List<int> decodeBase58To25Bytes(String input) {
    BigInt number = BigInt.zero;
    for (String t in input.split('')) {
      int p = ALPHABET.indexOf(t);
      if (p == (-1))
        return null;
      number = number * (BigInt.from(58)) + (BigInt.from(p));
    }
    List<int> result = new List<int>(24);
    List<int> numBytes = bigIntToByteArray(number);
    return arrayCopy(
        numBytes, 0, result, result.length - numBytes.length, numBytes.length);
  }

  validateAddress(String address) {
    List<int> decoded = new List.from(decodeBase58To25Bytes(address));
    List<int> temp = new List<int>.from(decoded);
    temp.insert(0, 0);
    List<int> hash1 = sha256.convert(temp.sublist(0, 21)).bytes;
    List<int> hash2 = sha256.convert(hash1).bytes;
    if (hash2[0] != decoded[20] ||
        hash2[1] != decoded[21] ||
        hash2[2] != decoded[22] ||
        hash2[3] != decoded[23]) return false;
    return true;
  }
}
