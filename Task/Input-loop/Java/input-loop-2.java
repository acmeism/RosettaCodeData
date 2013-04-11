import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
...
try{
	BufferedReader inp = new BufferedReader(new InputStreamReader(System.in));//stdin
	//new BufferedReader(new FileReader(filename)) for a file
	//new BufferedReader(new InputStreamReader(socket.getInputStream())) for a network stream
		while(inp.ready()){
			String input = inp.readLine();//line-by-line only
			//in.read() for character-by-character
			//process the input here
		}
} catch (IOException e) {
	//There was an input error
}
