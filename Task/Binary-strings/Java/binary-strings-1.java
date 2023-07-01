import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class MutableByteString {

    private byte[] bytes;
    private int length;

    public MutableByteString(byte... bytes) {
        setInternal(bytes);
    }

    public int length() {
        return length;
    }

    public boolean isEmpty() {
        return length == 0;
    }

    public byte get(int index) {
        return bytes[check(index)];
    }

    public void set(byte[] bytes) {
        setInternal(bytes);
    }

    public void set(int index, byte b) {
        bytes[check(index)] = b;
    }

    public void append(byte b) {
        if (length >= bytes.length) {
            int len = 2 * bytes.length;
            if (len < 0)
                len = Integer.MAX_VALUE;
            bytes = Arrays.copyOf(bytes, len);
        }
        bytes[length] = b;
        length++;
    }

    public MutableByteString substring(int from, int to) {
        return new MutableByteString(Arrays.copyOfRange(bytes, from, to));
    }

    public void replace(byte[] from, byte[] to) {
        ByteArrayOutputStream copy = new ByteArrayOutputStream();
        if (from.length == 0) {
            for (byte b : bytes) {
                copy.write(to, 0, to.length);
                copy.write(b);
            }
            copy.write(to, 0, to.length);
        } else {
            for (int i = 0; i < length; i++) {
                if (regionEquals(i, from)) {
                    copy.write(to, 0, to.length);
                    i += from.length - 1;
                } else {
                    copy.write(bytes[i]);
                }
            }
        }
        set(copy.toByteArray());
    }

    public boolean regionEquals(int offset, MutableByteString other, int otherOffset, int len) {
        if (Math.max(offset, otherOffset) + len < 0)
            return false;
        if (offset + len > length || otherOffset + len > other.length())
            return false;
        for (int i = 0; i < len; i++) {
            if (bytes[offset + i] != other.get(otherOffset + i))
                return false;
        }
        return true;
    }

    public String toHexString() {
        char[] hex = new char[2 * length];
        for (int i = 0; i < length; i++) {
            hex[2 * i] = "0123456789abcdef".charAt(bytes[i] >> 4 & 0x0F);
            hex[2 * i + 1] = "0123456789abcdef".charAt(bytes[i] & 0x0F);
        }
        return new String(hex);
    }

    public String toStringUtf8() {
        return new String(bytes, 0, length, StandardCharsets.UTF_8);
    }

    private void setInternal(byte[] bytes) {
        this.bytes = bytes.clone();
        this.length = bytes.length;
    }

    private boolean regionEquals(int offset, byte[] other) {
        int len = other.length;
        if (offset < 0 || offset + len < 0)
            return false;
        if (offset + len > length)
            return false;
        for (int i = 0; i < len; i++) {
            if (bytes[offset + i] != other[i])
                return false;
        }
        return true;
    }

    private int check(int index) {
        if (index < 0 || index >= length)
            throw new IndexOutOfBoundsException(String.valueOf(index));
        return index;
    }
}
