import org.apache.commons.io.IOUtils;
import java.net.URL;

public class Main {	
    public static void main(String[] args) throws Exception {
        IOUtils.copy(new URL("http://rosettacode.org").openStream(),System.out);    	    	    		
    }
}
