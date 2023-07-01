import static org.hamcrest.CoreMatchers.is;

import java.nio.charset.StandardCharsets;
import org.junit.Assert;
import org.junit.Test;

public class MutableByteStringTest {

    @Test
    public void testReplaceEmpty() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8));
        str.replace(new byte[]{}, new byte[]{'-'});

        Assert.assertThat(str.toStringUtf8(), is("-h-e-l-l-o-"));
    }

    @Test
    public void testReplaceMultiple() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8));
        str.replace(new byte[]{'l'}, new byte[]{'1', '2', '3'});

        Assert.assertThat(str.toStringUtf8(), is("he123123o"));
    }

    @Test
    public void testToHexString() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8));

        Assert.assertThat(str.toHexString(), is("68656c6c6f"));
    }

    @Test
    public void testAppend() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8));
        str.append((byte) ',');
        str.append((byte) ' ');
        str.append((byte) 'w');
        str.append((byte) 'o');
        str.append((byte) 'r');
        str.append((byte) 'l');
        str.append((byte) 'd');

        Assert.assertThat(str.toStringUtf8(), is("hello, world"));
    }
    @Test
    public void testSubstring() {
        MutableByteString str = new MutableByteString("hello, world".getBytes(StandardCharsets.UTF_8));

        Assert.assertThat(str.substring(0, 5).toStringUtf8(), is("hello"));
        Assert.assertThat(str.substring(7, 12).toStringUtf8(), is("world"));
    }

    @Test
    public void testRegionEquals() {
        MutableByteString str = new MutableByteString("hello".getBytes(StandardCharsets.UTF_8));

        Assert.assertThat(str.regionEquals(0, new MutableByteString(new byte[]{'h'}), 0, 1), is(true));
        Assert.assertThat(str.regionEquals(0, new MutableByteString(new byte[]{'h'}), 0, 2), is(false));
    }
}
