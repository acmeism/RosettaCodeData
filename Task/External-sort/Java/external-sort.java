import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.concurrent.ThreadLocalRandom;

public final class ExternalSort {
	
	 public static void main(String[] args) throws IOException {
		 Path inputPath = Path.of("./input.txt");
	     Path outputPath = Path.of("./output.txt");
	
		 // Create a "large" input file of a bounded random size
	     ThreadLocalRandom random = ThreadLocalRandom.current();
	     try ( BufferedWriter writer = Files.newBufferedWriter(inputPath, StandardCharsets.UTF_8) ) {
             for ( int i = 0; i < random.nextInt(80, 100); i++ ) {            	
                 writer.write(random.nextInt(0, 100) + "\n");
             }
         }
	
	     final int inMemoryFileSize = 20;
	     final long tempFileCount = Files.lines(inputPath).count() / inMemoryFileSize + 1;
	
	     createTemporaryFiles(inputPath, inMemoryFileSize);
	     mergeFiles(outputPath, inMemoryFileSize, tempFileCount);
    }
	
    private static void createTemporaryFiles(Path inputPath, int inMemoryFileSize) throws IOException {
        try ( BufferedReader inputFileReader = Files.newBufferedReader(inputPath) ) {
	        List<BufferedWriter> outputFileWriters = new ArrayList<BufferedWriter>();
	
	        int tempFileIndex = 0;
	        boolean inputAvailable = true;
	
	        while ( inputAvailable ) {
	            List<Integer> data = new ArrayList<Integer>();
	            for ( int i = 0; i < inMemoryFileSize && inputAvailable; i++ ) {
	                String line = inputFileReader.readLine();
	                if ( line != null ) {
	                    data.add(Integer.parseInt(line));
	                } else {
	                    inputAvailable = false;
	                }
	            }
	
	            Collections.sort(data);
	
	            // Write the elements to the appropriate temporary output file
	            Path tempPath = Path.of(String.valueOf(tempFileIndex));
	            outputFileWriters.addLast( Files.newBufferedWriter(tempPath, StandardCharsets.UTF_8) );
	            for ( int element : data ) {
	                outputFileWriters.get(tempFileIndex).write(element + "\n");
	            }
	            outputFileWriters.get(tempFileIndex).close();
	
	            tempFileIndex += 1;
	        }
        }
    }
	
    private static void mergeFiles(
    		Path outputPath, int inMemoryFileSize, long tempFileCount) throws IOException {
        try ( BufferedWriter writer = Files.newBufferedWriter(outputPath, StandardCharsets.UTF_8) ) {
	        List<BufferedReader> readers = new ArrayList<BufferedReader>();
	        Comparator<Node> custom = Comparator.comparingInt( a -> a.element );
	        PriorityQueue<Node> priorityQueue = new PriorityQueue<Node>(custom);
	
	        // Read the output files and place an element from each file into the priority queue
	        for ( int i = 0; i < tempFileCount; i++ ) {
	            readers.addLast( Files.newBufferedReader(Path.of(String.valueOf(i))) );
	            String element = readers.get(i).readLine();
	            if ( element != null ) {
	                priorityQueue.add( new Node(Integer.parseInt(element), i) );
	            }	
	        }
	
	        while ( ! priorityQueue.isEmpty() ) {
	            // Remove the minimum node from the priority queue and store it in the output file
	            Node node = priorityQueue.poll();
	            writer.write(node.element + "\n");
	
	            // Replace the node removed from the priority queue
	            String element = readers.get(node.fileIndex).readLine();
	            if ( element != null ) {
	                priorityQueue.add( new Node(Integer.parseInt(element), node.fileIndex) );
	            }
	        }
	
	        // Delete temporary files
	        for ( int i = 0; i < tempFileCount; i++ ) {
	        	Files.delete(Path.of(String.valueOf(i)));
	        }
        }
    }

    private static record Node(int element, int fileIndex) {}

}
