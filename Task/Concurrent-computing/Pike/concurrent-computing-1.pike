int main() {
	// Start threads and wait for them to finish
	({
		Thread.Thread(write, "Enjoy\n"),
		Thread.Thread(write, "Rosetta\n"),
		Thread.Thread(write, "Code\n")
	})->wait();
	
	// Exit program
	exit(0);
}
