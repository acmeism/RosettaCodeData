public static int[] countLetters(String filename) throws IOException{
	int[] freqs = new int[26];
	try(BufferedReader in = new BufferedReader(new FileReader(filename))){
		String line;
		while((line = in.readLine()) != null){
			line = line.toUpperCase();
			for(char ch:line.toCharArray()){
				if(Character.isLetter(ch)){
					freqs[ch - 'A']++;
				}
			}
		}
	}
	return freqs;
}
