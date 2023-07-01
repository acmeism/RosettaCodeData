import java.util.Random;
import java.util.concurrent.CountDownLatch;

public class Sync {
	static class Worker implements Runnable {
		private final CountDownLatch doneSignal;
		private int threadID;

		public Worker(int id, CountDownLatch doneSignal) {
			this.doneSignal = doneSignal;
			threadID = id;
		}

		public void run() {
			doWork();
			doneSignal.countDown();
		}

		void doWork() {
			try {
				int workTime = new Random().nextInt(900) + 100;
				System.out.println("Worker " + threadID + " will work for " + workTime + " msec.");
				Thread.sleep(workTime); //work for 'workTime'
				System.out.println("Worker " + threadID + " is ready");
			} catch (InterruptedException e) {
				System.err.println("Error: thread execution interrupted");
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		int n = 3;//6 workers and 3 tasks
		for(int task = 1; task <= n; task++) {
			CountDownLatch latch = new CountDownLatch(n * 2);
			System.out.println("Starting task " + task);
			for(int worker = 0; worker < n * 2; worker++) {
				new Thread(new Worker(worker, latch)).start();
			}
			try {
				latch.await();//wait for n*2 threads to signal the latch
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			System.out.println("Task " + task + " complete");
		}
	}
}
