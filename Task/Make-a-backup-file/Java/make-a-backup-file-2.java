import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

public class Backup{
	public static void saveWithBackup(String filename, String... data)
						throws IOException{
		File orig = new File(filename);
		//getCanonicalPath() follows symlinks to their ends
		File backup = new File(orig.getCanonicalPath() + ".backup");
		
		orig.renameTo(backup);
		PrintWriter output = new PrintWriter(orig);
		for(int i = 0; i < data.length; i++) {
			output.print(data[i]);
			if(i < data.length - 1) {
				output.println();
			}
		}
		output.close();
	}

        public static void main(String[] args) {
		try {
			saveWithBackup("original.txt", "fourth", "fifth", "sixth");
		} catch (IOException e) {
			System.err.println(e);
		}
	}
}
