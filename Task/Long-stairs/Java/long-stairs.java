import java.util.concurrent.ThreadLocalRandom;

public final class LongStairs {

	public static void main(String[] args) {
		final int trialCount = 10_000;
		double totalSeconds = 0.0;
		double totalSteps = 0.0;
		ThreadLocalRandom random = ThreadLocalRandom.current();
		
		System.out.println("Seconds    Steps behind    Steps ahead");
		System.out.println("-------    ------------    -----------");
		
		for ( int trial = 0; trial < trialCount; trial++ ) {
		    int stepsBehind = 0;
		    int stepCount = 100;
		    int seconds = 0;
		    while ( stepsBehind < stepCount ) {
		        stepsBehind += 1;
		        for ( int wizard = 0; wizard < 5; wizard++ ) {
		            if ( random.nextInt(0, stepCount) < stepsBehind ) {
		            	stepsBehind += 1;
		            }
		            stepCount += 1;
		        }
		        seconds += 1;
		
		        if ( trial == 0 && seconds >= 600 && seconds <= 609 ) {
		            System.out.println(String.format("%5d%14d%15d",	seconds, stepsBehind, stepCount - stepsBehind));
		        }
		    }
		    totalSeconds += seconds;
		    totalSteps += stepCount;
		}
		
		System.out.println();
		System.out.println("Average time taken in seconds: " + totalSeconds / trialCount);
		System.out.println("Average final length of the staircase: " + totalSteps / trialCount);
	}

}
