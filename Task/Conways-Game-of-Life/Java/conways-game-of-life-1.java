public class GameOfLife{
	public static void main(String[] args){
		String[] dish= {
				"_#_",
				"_#_",
				"_#_",};
		int gens= 3;
		for(int i= 0;i < gens;i++){
			System.out.println("Generation " + i + ":");
			print(dish);
			dish= life(dish);
		}
	}

	public static String[] life(String[] dish){
		String[] newGen= new String[dish.length];
		for(int row= 0;row < dish.length;row++){//each row
			newGen[row]= "";
			for(int i= 0;i < dish[row].length();i++){//each char in the row
				String above= "";//neighbors above
				String same= "";//neighbors in the same row
				String below= "";//neighbors below
				if(i == 0){//all the way on the left
					//no one above if on the top row
					//otherwise grab the neighbors from above
					above= (row == 0) ? null : dish[row - 1].substring(i,
									i + 2);
					same= dish[row].substring(i + 1, i + 2);
					//no one below if on the bottom row
					//otherwise grab the neighbors from below
					below= (row == dish.length - 1) ? null : dish[row + 1]
									.substring(i, i + 2);
				}else if(i == dish[row].length() - 1){//right
					//no one above if on the top row
					//otherwise grab the neighbors from above
					above= (row == 0) ? null : dish[row - 1].substring(i - 1,
									i + 1);
					same= dish[row].substring(i - 1, i);
					//no one below if on the bottom row
					//otherwise grab the neighbors from below
					below= (row == dish.length - 1) ? null : dish[row + 1]
									.substring(i - 1, i + 1);
				}else{//anywhere else
					//no one above if on the top row
					//otherwise grab the neighbors from above
					above= (row == 0) ? null : dish[row - 1].substring(i - 1,
									i + 2);
					same= dish[row].substring(i - 1, i)
									+ dish[row].substring(i + 1, i + 2);
					//no one below if on the bottom row
					//otherwise grab the neighbors from below
					below= (row == dish.length - 1) ? null : dish[row + 1]
									.substring(i - 1, i + 2);
				}
				int neighbors= getNeighbors(above, same, below);
				if(neighbors < 2 || neighbors > 3){
					newGen[row]+= "_";//<2 or >3 neighbors -> die
				}else if(neighbors == 3){
					newGen[row]+= "#";//3 neighbors -> spawn/live
				}else{
					newGen[row]+= dish[row].charAt(i);//2 neighbors -> stay
				}
			}
		}
		return newGen;
	}

	public static int getNeighbors(String above, String same, String below){
		int ans= 0;
		if(above != null){//no one above
			for(char x: above.toCharArray()){//each neighbor from above
				if(x == '#') ans++;//count it if someone is here
			}
		}
		for(char x: same.toCharArray()){//two on either side
			if(x == '#') ans++;//count it if someone is here
		}
		if(below != null){//no one below
			for(char x: below.toCharArray()){//each neighbor below
				if(x == '#') ans++;//count it if someone is here
			}
		}
		return ans;
	}

	public static void print(String[] dish){
		for(String s: dish){
			System.out.println(s);
		}
	}
}
