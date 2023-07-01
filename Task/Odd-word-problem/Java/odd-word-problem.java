public class OddWord {
    interface CharHandler {
	CharHandler handle(char c) throws Exception;
    }
    final CharHandler fwd = new CharHandler() {
	public CharHandler handle(char c) {
	    System.out.print(c);
	    return (Character.isLetter(c) ? fwd : rev);
	}
    };
    class Reverser extends Thread implements CharHandler {
	Reverser() {
	    setDaemon(true);
	    start();
	}
	private Character ch; // For inter-thread comms
	private char recur() throws Exception {
	    notify();
	    while (ch == null) wait();
	    char c = ch, ret = c;
	    ch = null;
	    if (Character.isLetter(c)) {
		ret = recur();
		System.out.print(c);
	    }
	    return ret;
	}
	public synchronized void run() {
	    try {
		while (true) {
		    System.out.print(recur());
		    notify();
		}
	    } catch (Exception e) {}
	}
	public synchronized CharHandler handle(char c) throws Exception {
	    while (ch != null) wait();
	    ch = c;
	    notify();
	    while (ch != null) wait();
	    return (Character.isLetter(c) ? rev : fwd);
	}
    }
    final CharHandler rev = new Reverser();

    public void loop() throws Exception {
	CharHandler handler = fwd;
	int c;
	while ((c = System.in.read()) >= 0) {
	    handler = handler.handle((char) c);
	}
    }

    public static void main(String[] args) throws Exception {
	new OddWord().loop();
    }
}
