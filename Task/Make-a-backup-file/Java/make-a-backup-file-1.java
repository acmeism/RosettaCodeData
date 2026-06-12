import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.*;

public class Backup {
	public static void saveWithBackup(String filename, String... data)
        throws IOException {
		//toRealPath() follows symlinks to their ends
		Path file = Paths.get(filename).toRealPath();
		File backFile = new File(filename + ".backup");
		if(!backFile.exists()) {
			// ensure the backup file exists so we can write to it later
			backFile.createNewFile();
		}
		Path back = Paths.get(filename + ".backup").toRealPath();
		Files.move(file, back, StandardCopyOption.REPLACE_EXISTING);
		try(PrintWriter out = new PrintWriter(file.toFile())){
			for(int i = 0; i < data.length; i++) {
				out.print(data[i]);
				if(i < data.length - 1) {
					out.println();
				}
			}
		}
	}

        public static void main(String[] args) {
		try {
			saveWithBackup("original.txt", "fourth", "fifth", "sixth");
		} catch (IOException e) {
			System.err.println(e);
		}
	}
}
