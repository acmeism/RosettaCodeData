import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

public final class SyncSubtitles {

	public static void main(String[] args) throws IOException {
		System.out.println("After fast-forwarding by 9 seconds:" + System.lineSeparator());
		syncSubtitles("./movie.srt", "./movie_amended.srt", 9);
		Files.lines(Path.of("./movie_amended.srt")).forEach(System.out::println);
		System.out.println();
		
		System.out.println("After rolling back by 9 seconds:" + System.lineSeparator());
		syncSubtitles("./movie.srt", "./movie_amended.srt", -9);
		Files.lines(Path.of("./movie_amended.srt")).forEach(System.out::println);
	}
	
	private static void syncSubtitles(String sourceFile, String targetFile, int seconds) throws IOException {
		final String arrow = " --> ";
		try ( BufferedReader reader = Files.newBufferedReader(Path.of(sourceFile));
			BufferedWriter writer = Files.newBufferedWriter(Path.of(targetFile)) ) {
			for ( String line = reader.readLine(); line != null; line = reader.readLine() ) {
				final int index = line.strip().indexOf(arrow);
		    	if ( index < 0 ) {
		    		writer.write(line + System.lineSeparator());		    		
		    	} else {		    		
		    		String startTime = addSeconds(line.substring(0, index), seconds);
		    		String finishTime = addSeconds(line.substring(index + arrow.length()), seconds);
		    		writer.write(startTime + arrow + finishTime + System.lineSeparator());				
		    	}		    		
			}
		}		
	}
	
	private static String addSeconds(String time, int seconds) {
		LocalTime original = LocalTime.parse(time.replace(',', '.')); // convert time to ISO-8601 standard
		LocalTime adjusted = original.plus(seconds, ChronoUnit.SECONDS);
		return adjusted.toString().replace('.', ','); // convert time back from ISO-8601 standard
	}

}
