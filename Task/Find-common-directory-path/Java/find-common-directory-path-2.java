	static String commonPath(String...  paths){
		String commonPath = "";
		String[][] folders = new String[paths.length][];
		
		for(int i=0; i<paths.length; i++){
			folders[i] = paths[i].split("/");
		}
			
		for(int j = 0; j< folders[0].length; j++){
			String s = folders[0][j];
			for(int i=1; i<paths.length; i++){
				if(!s.equals(folders[i][j]))
					return commonPath;
			}
			commonPath += s + "/";
		}
		return commonPath;		
	}
