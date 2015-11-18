private final static String ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

public static void main(String[] args) {
    Assert("Test 01", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"), true);
    Assert("Test 02", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j"), false);
    Assert("Test 03", ValidateBitcoinAddress("1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9"), true);
    Assert("Test 04", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X"), false);
    Assert("Test 05", ValidateBitcoinAddress("1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"), false);
    Assert("Test 06", ValidateBitcoinAddress("1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"), false);
    Assert("Test 07", ValidateBitcoinAddress("BZbvjr"), false);
    Assert("Test 08", ValidateBitcoinAddress("i55j"), false);
    Assert("Test 09", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!"), false);
    Assert("Test 10", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz"), false);
    Assert("Test 11", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz"), false);
    Assert("Test 12", ValidateBitcoinAddress("1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9"), false);
    Assert("Test 13", ValidateBitcoinAddress("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I"), false);
}

public static boolean ValidateBitcoinAddress(String addr) {
    if (addr.length() < 26 || addr.length() > 35) return false;
    byte[] decoded = DecodeBase58(addr, 58, 25);
    if (decoded == null) return false;

    byte[] hash = Sha256(decoded, 0, 21, 2);

    return Arrays.equals(Arrays.copyOfRange(hash, 0, 4), Arrays.copyOfRange(decoded, 21, 25));
}

private static byte[] DecodeBase58(String input, int base, int len) {
    byte[] output = new byte[len];
    for (int i = 0; i < input.length(); i++) {
        char t = input.charAt(i);

        int p = ALPHABET.indexOf(t);
        if (p == -1) return null;
        for (int j = len - 1; j > 0; j--, p /= 256) {
            p += base * (output[j] & 0xFF);
            output[j] = (byte) (p % 256);
        }
        if (p != 0) return null;
    }

    return output;
}

private static byte[] Sha256(byte[] data, int start, int len, int recursion) {
    if (recursion == 0) return data;

    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(Arrays.copyOfRange(data, start, start + len));
        return Sha256(md.digest(), 0, 32, recursion - 1);
    } catch (NoSuchAlgorithmException e) {
        return null;
    }
}

public static void Assert(String name, boolean value, boolean expected) {
    if (value ^ expected)
        throw new Error("Test " + name + " failed");
    else
        System.out.println(name + " passed");
}
