import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class MultitonTask {
	
    public static void main(String[] args) {
        Multiton alpha = Multiton.getInstance(MultitonType.ZERO);
        Multiton beta  = Multiton.getInstance(MultitonType.ZERO);
        Multiton gamma = Multiton.getInstance(MultitonType.ONE);
        Multiton delta = Multiton.getInstance(MultitonType.TWO);

        System.out.println(alpha);
        System.out.println(beta);
        System.out.println(gamma);
        System.out.println(delta);
    }

    private enum MultitonType { ZERO, ONE, TWO }

    private static final class Multiton {
    	
    	// Thread safe method.
    	// Even if the enum 'MultitonType' is maliciously altered to include extra or different enum values,
    	// for example, 'THREE', the method will return null because the hash map does not contain the enum value.
        public static synchronized Multiton getInstance(MultitonType type) {        	
        	return instances.getOrDefault(type, null);
        }

        @Override
        public String toString() {
            return "This is Multiton " + type;
        }

        // Private constructor to prevent the class being instantiated
    	private Multiton(MultitonType aType) {
    	    type = aType;
    	}
    	
    	private MultitonType type;
    	
    	// Thread safe hash map
    	private static Map<MultitonType, Multiton> instances = new ConcurrentHashMap<MultitonType, Multiton>();
    	
    	// Create and pre-load into the map all available instances
    	static {
    		instances.put(MultitonType.ZERO, new Multiton(MultitonType.ZERO));
    		instances.put(MultitonType.ONE, new Multiton(MultitonType.ONE));
    		instances.put(MultitonType.TWO, new Multiton(MultitonType.TWO));
    	}
    	
    }

}
