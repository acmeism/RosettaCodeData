int main() {
	int seconds = (int)Stdio.stdin->gets();
	write("Sleeping...\n");
	sleep(seconds);
	write("Awake!\n");
	return 0;
}
