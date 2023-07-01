public class Life{
	private static char[] trans = "___#_##_".toCharArray();

	private static int v(StringBuilder cell, int i){
		return (cell.charAt(i) != '_') ? 1 : 0;
	}

	public static boolean evolve(StringBuilder cell){
		boolean diff = false;
		StringBuilder backup = new StringBuilder(cell.toString());

		for(int i = 1; i < cell.length() - 3; i++){
			/* use left, self, right as binary number bits for table index */
			backup.setCharAt(i, trans[v(cell, i - 1) * 4 + v(cell, i) * 2
			      					+ v(cell, i + 1)]);
			diff = diff || (backup.charAt(i) != cell.charAt(i));
		}

		cell.delete(0, cell.length());//clear the buffer
		cell.append(backup);//replace it with the new generation
		return diff;
	}

	public static void main(String[] args){
		StringBuilder  c = new StringBuilder("_###_##_#_#_#_#__#__\n");

		do{
			System.out.printf(c.substring(1));
		}while(evolve(c));
	}
}
