public static <E> List<E> getNNewObjects(int n, Class<? extends E> c){
	List<E> ans = new LinkedList<E>();
	try {
		for(int i=0;i<n;i++)
			ans.add(c.newInstance());//can't call new on a class object
	} catch (InstantiationException e) {
		e.printStackTrace();
	} catch (IllegalAccessException e) {
		e.printStackTrace();
	}
	return ans;
}

public static List<Object> getNNewObjects(int n, String className)
throws ClassNotFoundException{
	return getNNewObjects(n, Class.forName(className));
}
