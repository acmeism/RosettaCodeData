import org.testng.Assert
import org.testng.annotations.Test

import java.nio.charset.StandardCharsets

class MutableByteStringTest {
    @Test
    void replaceEmpty() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8))
        str.replace([] as byte[], ['-' as char] as byte[])

        Assert.assertEquals(str.toStringUtf8(), "-h-e-l-l-o-")
    }

    @Test
    void replaceMultiple() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8))
        str.replace(['l' as char] as byte[], ['1' as char, '2' as char, '3' as char] as byte[])

        Assert.assertEquals(str.toStringUtf8(), "he123123o")
    }

    @Test
    void toHexString() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8))

        Assert.assertEquals(str.toHexString(), "68656c6c6f")
    }

    @Test
    void append() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8))
        str.append((',' as char) as byte)
        str.append((' ' as char) as byte)
        str.append(('w' as char) as byte)
        str.append(('o' as char) as byte)
        str.append(('r' as char) as byte)
        str.append(('l' as char) as byte)
        str.append(('d' as char) as byte)

        Assert.assertEquals(str.toStringUtf8(), "hello, world")
    }

    @Test
    void substring() {
        MutableByteString str = new MutableByteString("hello, world".getBytes(StandardCharsets.UTF_8))

        Assert.assertEquals(str.substring(0, 5).toStringUtf8(), "hello")
        Assert.assertEquals(str.substring(7, 12).toStringUtf8(), "world")
    }

    @Test
    void regionEquals(){
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8))

        Assert.assertTrue(str.regionEquals(0, new MutableByteString(['h' as char] as byte[]), 0, 1))
        Assert.assertFalse(str.regionEquals(0, new MutableByteString(['h' as char] as byte[]), 0, 2))
    }
}
