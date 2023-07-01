import com.google.common.collect.Streams;
import java.util.function.Supplier;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import static java.nio.charset.StandardCharsets.US_ASCII;

public class VigenereCipher {
    private final static int LOWER = 'A';
    private final static int UPPER = 'Z';
    private final static int SIZE = UPPER - LOWER + 1;
    private final Supplier<Stream<Character>> maskStream;

    public VigenereCipher(final String key) {
        final String mask = new String(key.getBytes(US_ASCII)).toUpperCase();
        maskStream = () ->
                Stream.iterate(0, i -> (i+1) % mask.length()).map(mask::charAt);
    }

    private String transform(final String text, final boolean encode) {
        final Stream<Integer> textStream = text.toUpperCase().chars().boxed()
                .filter(i -> i >= LOWER && i <= UPPER);
        return Streams.zip(textStream, maskStream.get(), (c, m) ->
                encode ? c + m - 2 * LOWER : c - m + SIZE)
            .map(c -> Character.toString(c % SIZE + LOWER))
            .collect(Collectors.joining());
    }

    public String encrypt(final String plaintext) {
        return transform(plaintext,true);
    }

    public String decrypt(final String ciphertext) {
        return transform(ciphertext,false);
    }
}

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class VigenereCipherTest {
    private static final VigenereCipher Vigenere = new VigenereCipher("VIGENERECIPHER");

    @Test
    @DisplayName("encipher/decipher round-trip succeeds")
    void vigenereCipherTest() {
        final String input = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
        final String expectEncrypted = "WMCEEIKLGRPIFVMEUGXQPWQVIOIAVEYXUEKFKBTALVXTGAFXYEVKPAGY";
        final String expectDecrypted = "BEWARETHEJABBERWOCKMYSONTHEJAWSTHATBITETHECLAWSTHATCATCH";

        final String ciphertext = Vigenere.encrypt(input);
        assertEquals(expectEncrypted, ciphertext);

        final String plaintext = Vigenere.decrypt(ciphertext);
        assertEquals(expectDecrypted, plaintext);
    }

}
