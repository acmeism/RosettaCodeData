shared void run() {

    function normalize(String text) => text.uppercased.filter(Character.letter);

    function crypt(String text, String key, Character(Character, Character) transform) => String {
        for ([a, b] in zipPairs(normalize(text), normalize(key).cycled))
        transform(a, b)
    };

    function encrypt(String clearText, String key) =>
            crypt(clearText, key, (Character a, Character b) =>
				('A'.integer + ((a.integer + b.integer - 130) % 26)).character);

    function decrypt(String cipherText, String key) =>
            crypt(cipherText, key, (Character a, Character b) =>
        		('A'.integer + ((a.integer - b.integer + 26) % 26)).character);

    value key = "VIGENERECIPHER";
    value message = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
    value encrypted = encrypt(message, key);
    value decrypted = decrypt(encrypted, key);

    print(encrypted);
    print(decrypted);
}
