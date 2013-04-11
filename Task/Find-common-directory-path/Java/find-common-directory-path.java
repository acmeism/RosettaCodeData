public class CommonPath {
	public static String commonPath(String... paths){
		String commonPath = "";
		String[][] folders = new String[paths.length][];
		for(int i = 0; i < paths.length; i++){
			folders[i] = paths[i].split("/"); //split on file separator
		}
		for(int j = 0; j < folders[0].length; j++){
			String thisFolder = folders[0][j]; //grab the next folder name in the first path
			boolean allMatched = true; //assume all have matched in case there are no more paths
			for(int i = 1; i < folders.length && allMatched; i++){ //look at the other paths
				if(folders[i].length < j){ //if there is no folder here
					allMatched = false; //no match
					break; //stop looking because we've gone as far as we can
				}
				//otherwise
				allMatched &= folders[i][j].equals(thisFolder); //check if it matched
			}
			if(allMatched){ //if they all matched this folder name
				commonPath += thisFolder + "/"; //add it to the answer
			}else{//otherwise
				break;//stop looking
			}
		}
		return commonPath;
	}
	
	public static void main(String[] args){
		String[] paths = { "/home/user1/tmp/coverage/test",
				 "/home/user1/tmp/covert/operator",
				 "/home/user1/tmp/coven/members"};
		System.out.println(commonPath(paths));
		
		String[] paths2 = { "/hame/user1/tmp/coverage/test",
				 "/home/user1/tmp/covert/operator",
				 "/home/user1/tmp/coven/members"};
		System.out.println(commonPath(paths2));
	}
}
