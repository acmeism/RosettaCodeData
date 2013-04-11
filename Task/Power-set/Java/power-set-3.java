public static <T extends Comparable<? super T>> LinkedList<LinkedList<T>> BinPowSet(
		LinkedList<T> A){
	LinkedList<LinkedList<T>> ans= new LinkedList<LinkedList<T>>();
	int ansSize = (int)Math.pow(2, A.size());
	for(Integer i= 0;i< ansSize;++i){
		String bin= Integer.toString(i, 2); //convert to binary
		while(bin.length() < A.size())bin = "0" + bin; //pad with 0's
		LinkedList<T> thisComb = new LinkedList<T>(); //place to put one combination
		for(int j= 0;j< A.size();++j){
			if(bin.charAt(j) == '1')thisComb.add(A.get(j));
		}
		Collections.sort(thisComb); //sort it for easy checking
		ans.add(thisComb); //put this set in the answer list
	}
	return ans;
}
