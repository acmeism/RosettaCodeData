public static int[] sort(int[] old) {
			
	for(int shift = Integer.SIZE-1; shift > -1; shift--) { //Loop for every bit in the integers
		
		int[] tmp = new int[old.length]; //the array to put the partially sorted array into
		int j = 0;  //The number of 0s

	
		for(int i = 0; i < old.length; i++) {  //Move the 0s to the new array, and the 1s to the old one
			
			boolean move = old[i] << shift >= 0;  //If there is a 1 in the bit we are testing, the number will be negative
			
			if(shift == 0 ? !move : move) {  //If this is the last bit, negative numbers are actually lower
				
				tmp[j] = old[i];
				j++;
				
			} else {  //It's a 1, so stick it in the old array for now
				
				old[i-j] = old[i];
				
			}
			
		}
		
		for(int i = j; i < tmp.length; i++) {  //Copy over the 1s from the old array
			
			tmp[i] = old[i-j];	
			
		}
		
		old = tmp;  //And now the tmp array gets switched for another round of sorting
		
	}
			
	return old;
	
}
