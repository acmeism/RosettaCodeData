import java.util.Scanner;
...
Scanner in = new Scanner(System.in);//stdin
//new Scanner(new FileInputStream(filename)) for a file
//new Scanner(socket.getInputStream()) for a network stream
while(in.hasNext()){
	String input = in.next(); //in.nextLine() for line-by-line
	//process the input here
}
