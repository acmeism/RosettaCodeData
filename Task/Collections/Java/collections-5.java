import scala.Tuple2;
import scala.collection.concurrent.TrieMap;
import scala.collection.immutable.HashSet;
import scala.collection.mutable.ArrayBuffer;

public class Collections {
	
	public static void main(String[] args) {
		ArrayBuffer<Integer> myarrlist = new ArrayBuffer<Integer>();
		ArrayBuffer<Integer> myarrlist2 = new ArrayBuffer<Integer>(20);

		myarrlist.$plus$eq(new Integer(42)); // $plus$eq is Scala += operator
		myarrlist.$plus$eq(13); // to add an element.
		myarrlist.$plus$eq(-1);

		myarrlist2.$plus$plus$eq(myarrlist);// //$plus$plus$eq is Scala ++= operator
		myarrlist2.$plus$plus$eq(myarrlist);

		myarrlist2 = (ArrayBuffer<Integer>) myarrlist2.$minus(-1);

		for (int i = 0; i < 10; i++)
			myarrlist2.$plus$eq(i);

		// loop through myarrlist to sum each entry
		int sum = 0;
		for (int i = 0; i < myarrlist2.size(); i++) {
			sum += myarrlist2.apply(i);
		}
		System.out.println("List is: " + myarrlist2 + " with head: "
				+ myarrlist2.head() + " sum is: " + sum);
		System.out.println("Third element is: " + myarrlist2.apply$mcII$sp(2));

		Tuple2<String, String> tuple = new Tuple2<String, String>("US",
				"Washington");
		System.out.println("Tuple2 is : " + tuple);

		ArrayBuffer<Tuple2<String, String>> capList = new ArrayBuffer<Tuple2<String, String>>();
		capList.$plus$eq(new Tuple2<String, String>("US", "Washington"));
		capList.$plus$eq(new Tuple2<String, String>("France", "Paris"));
		System.out.println(capList);

		TrieMap<String, String> trieMap = new TrieMap<String, String>();
		trieMap.put("US", "Washington");
		trieMap.put("France", "Paris");

		HashSet<Character> set = new HashSet<Character>();

		ArrayBuffer<Tuple2<String, String>> capBuffer = new ArrayBuffer<Tuple2<String, String>>();
		trieMap.put("US", "Washington");

		System.out.println(trieMap);
	}
}
