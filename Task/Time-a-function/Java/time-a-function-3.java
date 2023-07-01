	public static void main(String[] args){
		long start, end;
		start = System.currentTimeMillis();
		countTo(100000000);
		end = System.currentTimeMillis();
		System.out.println("Counting to 100000000 takes "+(end-start)+"ms");
		start = System.currentTimeMillis();
		countTo(1000000000L);
		end = System.currentTimeMillis();
		System.out.println("Counting to 1000000000 takes "+(end-start)+"ms");

	}
