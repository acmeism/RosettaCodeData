public class Values {
	private final Object[] objects;
	public Values(Object ... objects) {
		this.objects = objects;
	}
	public <T> T get(int i) {
		return (T) objects[i];
	}
	public Object[] get() {
		return objects;
	}
	
	// to test
	public static void main(String[] args) {
		Values v = getValues();
		int i = v.get(0);
		System.out.println(i);
		printValues(i, v.get(1));
		printValues(v.get());
	}
	private static Values getValues() {
		return new Values(1, 3.8, "text");
	}
	private static void printValues(int i, double d) {
		System.out.println(i + ", " + d);
	}
	private static void printValues(Object ... objects) {
		for (int i=0; i<objects.length; i+=1) System.out.print((i==0 ? "": ", ") + objects[i]);
		System.out.println();
	}
}
