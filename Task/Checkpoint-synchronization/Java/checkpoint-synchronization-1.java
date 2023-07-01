import java.util.Scanner;
import java.util.Random;

public class CheckpointSync{
	public static void main(String[] args){
		System.out.print("Enter number of workers to use: ");
		Scanner in = new Scanner(System.in);
		Worker.nWorkers = in.nextInt();
		System.out.print("Enter number of tasks to complete:");
		runTasks(in.nextInt());
	}
	
	/*
	 * Informs that workers started working on the task and
	 * starts running threads. Prior to proceeding with next
	 * task syncs using static Worker.checkpoint() method.
	 */
	private static void runTasks(int nTasks){
		for(int i = 0; i < nTasks; i++){
			System.out.println("Starting task number " + (i+1) + ".");
			runThreads();
			Worker.checkpoint();
		}
	}
	
	/*
	 * Creates a thread for each worker and runs it.
	 */
	private static void runThreads(){
		for(int i = 0; i < Worker.nWorkers; i ++){
			new Thread(new Worker(i+1)).start();
		}
	}
	
	/*
	 * Worker inner static class.
	 */
	public static class Worker implements Runnable{
		public Worker(int threadID){
			this.threadID = threadID;
		}
		public void run(){
			work();
		}
		
		/*
		 *  Notifies that thread started running for 100 to 1000 msec.
		 *  Once finished increments static counter 'nFinished'
		 *  that counts number of workers finished their work.
		 */
		private synchronized void work(){
			try {
				int workTime = rgen.nextInt(900) + 100;
				System.out.println("Worker " + threadID + " will work for " + workTime + " msec.");
				Thread.sleep(workTime); //work for 'workTime'
				nFinished++; //increases work finished counter
				System.out.println("Worker " + threadID + " is ready");
			} catch (InterruptedException e) {
				System.err.println("Error: thread execution interrupted");
				e.printStackTrace();
			}
		}
		
		/*
		 * Used to synchronize Worker threads using 'nFinished' static integer.
		 * Waits (with step of 10 msec) until 'nFinished' equals to 'nWorkers'.
		 * Once they are equal resets 'nFinished' counter.
		 */
		public static synchronized void checkpoint(){
			while(nFinished != nWorkers){
				try {
					Thread.sleep(10);
				} catch (InterruptedException e) {
					System.err.println("Error: thread execution interrupted");
					e.printStackTrace();
				}
			}
			nFinished = 0;
		}
	
		/* inner class instance variables */
		private int threadID;
		
		/* static variables */
		private static Random rgen = new Random();
		private static int nFinished = 0;
		public static int nWorkers = 0;
	}
}
