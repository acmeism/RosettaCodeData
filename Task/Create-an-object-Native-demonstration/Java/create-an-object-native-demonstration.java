import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

//  Title:  Create an object/Native demonstration

public class ImmutableMap {

    public static void main(String[] args) {
        Map<String,Integer> hashMap = getImmutableMap();
        try {
            hashMap.put("Test", 23);
        }
        catch (UnsupportedOperationException e) {
            System.out.println("ERROR:  Unable to put new value.");
        }
        try {
            hashMap.clear();
        }
        catch (UnsupportedOperationException e) {
            System.out.println("ERROR:  Unable to clear map.");
        }
        try {
            hashMap.putIfAbsent("Test", 23);
        }
        catch (UnsupportedOperationException e) {
            System.out.println("ERROR:  Unable to put if absent.");
        }

        for ( String key : hashMap.keySet() ) {
            System.out.printf("key = %s, value = %s%n", key, hashMap.get(key));
        }
    }

    private static Map<String,Integer> getImmutableMap() {
        Map<String,Integer> hashMap = new HashMap<>();
        hashMap.put("Key 1", 34);
        hashMap.put("Key 2", 105);
        hashMap.put("Key 3", 144);

        return Collections.unmodifiableMap(hashMap);
    }

}
