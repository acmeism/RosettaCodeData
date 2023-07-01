/* Query.java */
public class Query {
    public static boolean call(byte[] data, int[] length)
	throws java.io.UnsupportedEncodingException
    {
	String message = "Here am I";
	byte[] mb = message.getBytes("utf-8");
	if (length[0] < mb.length)
	    return false;
	length[0] = mb.length;
	System.arraycopy(mb, 0, data, 0, mb.length);
	return true;
    }
}
