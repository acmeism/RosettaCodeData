public static void main(String[] args) {
    /*
    This is probably not the best method...or even the most optimized way...however it works since n and d are too big to be ints or longs
    This was also only tested with 'Rosetta Code' and 'Hello World'
    It's also pretty limited on plainText size (anything bigger than the above will fail)
    */
    BigInteger n = new BigInteger("9516311845790656153499716760847001433441357");
    BigInteger e = new BigInteger("65537");
    BigInteger d = new BigInteger("5617843187844953170308463622230283376298685");
    Charset c = Charsets.UTF_8;
    String plainText = "Rosetta Code";
    System.out.println("PlainText : " + plainText);
    byte[] bytes = plainText.getBytes();
    BigInteger plainNum = new BigInteger(bytes);
    System.out.println("As number : " + plainNum);
    BigInteger Bytes = new BigInteger(bytes);
    if (Bytes.compareTo(n) == 1) {
        System.out.println("Plaintext is too long");
        return;
    }
    BigInteger enc = plainNum.modPow(e, n);
    System.out.println("Encoded: " + enc);
    BigInteger dec = enc.modPow(d, n);
    System.out.println("Decoded: " + dec);
    String decText = new String(dec.toByteArray(), c);
    System.out.println("As text: " + decText);
}
