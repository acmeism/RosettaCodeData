import java.util.Arrays;
import java.util.Random;

public class AtomicUpdates
{
  public static class Buckets
  {
    private final int[] data;

    public Buckets(int[] data)
    {
      this.data = data.clone();
    }

    public int getBucket(int index)
    {
      synchronized (data)
      {  return data[index];  }
    }

    public int transfer(int srcBucketIndex, int destBucketIndex, int amount)
    {
      if (amount == 0)
        return 0;
      // Negative transfers will happen in the opposite direction
      if (amount < 0)
      {
        int tempIndex = srcBucketIndex;
        srcBucketIndex = destBucketIndex;
        destBucketIndex = tempIndex;
        amount = -amount;
      }
      synchronized (data)
      {
        if (amount > data[srcBucketIndex])
          amount = data[srcBucketIndex];
        if (amount <= 0)
          return 0;
        data[srcBucketIndex] -= amount;
        data[destBucketIndex] += amount;
        return amount;
      }
    }

    public int[] getBuckets()
    {
      synchronized (data)
      {  return data.clone();  }
    }
  }

  public static int getTotal(int[] values)
  {
    int totalValue = 0;
    for (int i = values.length - 1; i >= 0; i--)
      totalValue += values[i];
    return totalValue;
  }

  public static void main(String[] args)
  {
    final int NUM_BUCKETS = 10;
    Random rnd = new Random();
    final int[] values = new int[NUM_BUCKETS];
    for (int i = 0; i < values.length; i++)
      values[i] = rnd.nextInt(10);
    System.out.println("Initial Array: " + getTotal(values) + " " + Arrays.toString(values));
    final Buckets buckets = new Buckets(values);

    new Thread(new Runnable() {
        public void run()
        {
          Random r = new Random();
          while (true)
          {
            int srcBucketIndex = r.nextInt(NUM_BUCKETS);
            int destBucketIndex = r.nextInt(NUM_BUCKETS);
            int amount = (buckets.getBucket(srcBucketIndex) - buckets.getBucket(destBucketIndex)) >> 1;
            if (amount != 0)
              buckets.transfer(srcBucketIndex, destBucketIndex, amount);
          }
        }
      }
    ).start();

    new Thread(new Runnable() {
        public void run()
        {
          Random r = new Random();
          while (true)
          {
            int srcBucketIndex = r.nextInt(NUM_BUCKETS);
            int destBucketIndex = r.nextInt(NUM_BUCKETS);
            int srcBucketAmount = buckets.getBucket(srcBucketIndex);
            int destBucketAmount = buckets.getBucket(destBucketIndex);
            int amount = r.nextInt(srcBucketAmount + destBucketAmount + 1) - destBucketAmount;
            if (amount != 0)
              buckets.transfer(srcBucketIndex, destBucketIndex, amount);
          }
        }
      }
    ).start();

    while (true)
    {
      long nextPrintTime = System.currentTimeMillis() + 3000;
      long curTime;
      while ((curTime = System.currentTimeMillis()) < nextPrintTime)
      {
        try
        {  Thread.sleep(nextPrintTime - curTime);  }
        catch (InterruptedException e)
        {  }
      }
      int[] bucketValues = buckets.getBuckets();
      System.out.println("Current values: " + getTotal(bucketValues) + " " + Arrays.toString(bucketValues));
    }
  }
}
