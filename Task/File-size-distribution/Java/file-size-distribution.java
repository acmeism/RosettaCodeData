import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class FileSizeDistribution {

	public static void main(String[] aArgs) throws IOException {		
		List<Path> fileNames = Files.list(Path.of("."))
			.filter( file -> ! Files.isDirectory(file) )
			.map(Path::getFileName)
			.toList();
		
		Map<Integer, Integer> fileSizes = new HashMap<Integer, Integer>();
		for ( Path path : fileNames ) {
			fileSizes.merge(String.valueOf(Files.size(path)).length(), 1, Integer::sum);
		}
		
		final int fileCount = fileSizes.values().stream().mapToInt(Integer::valueOf).sum();
		
		System.out.println("File size distribution for directory \".\":" + System.lineSeparator());
		System.out.println("File size in bytes | Number of files | Percentage");
		System.out.println("-------------------------------------------------");
		for ( int key : fileSizes.keySet() ) {
			final int value = fileSizes.get(key);
			System.out.println(String.format("%s%d%s%d%15d%15.1f%%",
				"   10^", ( key - 1 ), " to 10^", key, value, ( 100.0 * value ) / fileCount));
		}
	}

}
