import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;

public class TimeIt {
	public static void main(String[] args) {
		final ThreadMXBean threadMX = ManagementFactory.getThreadMXBean();
		assert threadMX.isCurrentThreadCpuTimeSupported();
		threadMX.setThreadCpuTimeEnabled(true);
		
		long start, end;
		start = threadMX.getCurrentThreadCpuTime();
		countTo(100000000);
		end = threadMX.getCurrentThreadCpuTime();
		System.out.println("Counting to 100000000 takes "+(end-start)/1000000+"ms");
		start = threadMX.getCurrentThreadCpuTime();
		countTo(1000000000L);
		end = threadMX.getCurrentThreadCpuTime();
		System.out.println("Counting to 1000000000 takes "+(end-start)/1000000+"ms");

	}

	public static void countTo(long x){
		System.out.println("Counting...");
		for(long i=0;i<x;i++);
		System.out.println("Done!");
	}
}
