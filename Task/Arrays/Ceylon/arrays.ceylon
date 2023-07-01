import ceylon.collection {

	ArrayList
}

shared void run() {
	
	// you can get an array from the Array.ofSize named constructor
	value array = Array.ofSize(10, "hello");
	value a = array[3];
	print(a);
	array[4] = "goodbye";
	print(array);
	
	// for a dynamic list import ceylon.collection in your module.ceylon file
	value list = ArrayList<String>();
	list.push("hello");
	list.push("hello again");
	print(list);
}
