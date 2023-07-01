import 'dart:isolate' show Isolate, ReceivePort;
import 'dart:io'      show exit, sleep;
import 'dart:math'    show Random;

main() {
	// Create ReceivePort to receive done messages
	// Called a channel in other languages
	var receiver = ReceivePort();

	// Create job counter
	var job_count = 3;
	
	// Create job pool
	var jobs = [ enjoy, rosetta, code ];

	// Create random number generator
	var rng = Random();

	for ( var job in jobs ) {
		// Sleep for random duration up to half a second
		var sleep_time = Duration( milliseconds: rng.nextInt( 500 ) );	

		// Spawn  Isolate to do work
		// When finished the second argument will be sent to the receiver via the SendPort specified in onExit
		Isolate.spawn( job, sleep_time, onExit: receiver.sendPort );

	}
	
	// Do something in main isolate
	print("from main isolate\n");
	
	// Register a listener on the ReceivePort, it gets called whenver something is sent on its SendPort
	// We'll ignore the message with _ because we don't care about the data, just the event
	receiver.listen( (_) {
		// Decrement job counter
		job_count -= 1; 	
		// If jobs are all finished
		if ( job_count == 0 ) {
			print("\nall jobs finished!");
			exit(0);
		}
	});

}

enjoy ( duration ) {
	sleep( duration ) ;
	print("Enjoy");
}

rosetta ( duration ) {
	sleep( duration );
	print("Rosetta");
 }

code ( duration ) {
	sleep( duration );
	print("Code");
}
