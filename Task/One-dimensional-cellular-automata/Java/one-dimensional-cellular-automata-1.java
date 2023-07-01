public class Life{
	public static void main(String[] args) throws Exception{
		String start= "_###_##_#_#_#_#__#__";
		int numGens = 10;
		for(int i= 0; i < numGens; i++){
			System.out.println("Generation " + i + ": " + start);
			start= life(start);
		}
	}

	public static String life(String lastGen){
		String newGen= "";
		for(int i= 0; i < lastGen.length(); i++){
			int neighbors= 0;
			if (i == 0){//left edge
				neighbors= lastGen.charAt(1) == '#' ? 1 : 0;
			} else if (i == lastGen.length() - 1){//right edge
				neighbors= lastGen.charAt(i - 1) == '#' ? 1 : 0;
			} else{//middle
				neighbors= getNeighbors(lastGen.substring(i - 1, i + 2));
			}

			if (neighbors == 0){//dies or stays dead with no neighbors
				newGen+= "_";
			}
			if (neighbors == 1){//stays with one neighbor
				newGen+= lastGen.charAt(i);
			}
			if (neighbors == 2){//flips with two neighbors
				newGen+= lastGen.charAt(i) == '#' ? "_" : "#";
			}
		}
		return newGen;
	}

	public static int getNeighbors(String group){
		int ans= 0;
		if (group.charAt(0) == '#') ans++;
		if (group.charAt(2) == '#') ans++;
		return ans;
	}
}
