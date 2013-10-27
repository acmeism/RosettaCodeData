import java.util.Arrays;
import java.util.Optional;
import java.util.Random;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public interface Buckets {
  public static Buckets new_(int[] data) {
    return $.new_(data);
  }
  public static void main(String... arguments) {
    $.main(arguments);
  }
  public int[] getBuckets();

  public int getBucket(int index);

  public int transfer(int srcBucketIndex, int destBucketIndex, int amount);

  public enum $ {
    $$;

    private static Buckets new_(int[] data) {
      return (FunctionalBuckets) function -> {
        synchronized (data) {
          return Optional.of(data)
            .map(function)
            .filter(output -> output != data)
            .orElseGet(() -> data.clone())
          ;
        }
      };
    }

    private static void main(String... arguments) {
      Stream.of(new Random())
        .parallel()
        .map(r -> r.ints($.NUM_BUCKETS, 0, NUM_BUCKETS))
        .map(IntStream::toArray)
        .peek(bucketValues -> Stream.of(bucketValues)
          .map(values -> "Initial values: " + getTotal(values) + " " + Arrays.toString(values))
          .forEach(System.out::println)
        )
        .map(Buckets::new_)
        .forEach(
          Stream.<Consumer<Buckets>>of(
            $::processBuckets,
            $::displayBuckets
          ).reduce($ -> {}, Consumer::andThen)
        )
      ;
    }

    @FunctionalInterface
    private static interface FunctionalBuckets extends Buckets {
      public Object untypedUseData(Function<int[], Object> function);

      @SuppressWarnings("unchecked")
      public default <OUTPUT> OUTPUT useData(Function<int[], OUTPUT> function) {
        return (OUTPUT) untypedUseData(function::apply);
      }

      @Override
      public default int[] getBuckets() {
        return useData(Function.<int[]>identity());
      }

      @Override
      public default int getBucket(int index) {
        return useData(data -> data[index]);
      }

      @Override
      public default int transfer(int originalSrcBucketIndex, int originalDestBucketIndex, int originalAmount) {
        return useData(data -> {
          int srcBucketIndex = originalSrcBucketIndex;
          int destBucketIndex = originalDestBucketIndex;
          int amount = originalAmount;
          if (amount == 0) {
            return 0;
          }
          // Negative transfers will happen in the opposite direction
          if (amount < 0) {
            int tempIndex = srcBucketIndex;
            srcBucketIndex = destBucketIndex;
            destBucketIndex = tempIndex;
            amount = -amount;
          }
          if (amount > data[srcBucketIndex]) {
            amount = data[srcBucketIndex];
          }
          if (amount <= 0) {
            return 0;
          }
          data[srcBucketIndex] -= amount;
          data[destBucketIndex] += amount;
          return amount;
        });
      }
    }

    private static final int NUM_BUCKETS = 10;
    private static final int PRINT_DELAY = 3_000;

    private static int getTotal(int[] values) {
      return Arrays.stream(values)
        .parallel()
        .sum()
      ;
    }

    private static void equalizeBuckets(Buckets buckets) {
      Random r = new Random();
      while (true) {
        int srcBucketIndex = r.nextInt($.NUM_BUCKETS);
        int destBucketIndex = r.nextInt($.NUM_BUCKETS);
        Stream.of(srcBucketIndex, destBucketIndex)
          .map(buckets::getBucket)
          .reduce((srcBucketAmount, destBucketAmount) ->
            srcBucketAmount - destBucketAmount
          )
          .map(amount -> amount >> 1)
          .filter(amount -> amount != 0)
          .ifPresent(amount ->
            buckets.transfer(srcBucketIndex, destBucketIndex, amount)
          )
        ;
      }
    }

    private static void randomizeBuckets (Buckets buckets) {
      Random r = new Random();
      while (true) {
        int srcBucketIndex = r.nextInt($.NUM_BUCKETS);
        int destBucketIndex = r.nextInt($.NUM_BUCKETS);
        Stream.of(srcBucketIndex, destBucketIndex)
          .map(buckets::getBucket)
          .reduce((srcBucketAmount, destBucketAmount) ->
            r.nextInt(srcBucketAmount + destBucketAmount + 1) - destBucketAmount
          )
          .filter(amount -> amount != 0)
          .ifPresent(amount ->
            buckets.transfer(srcBucketIndex, destBucketIndex, amount)
          )
        ;
      }
    }

    private static Runnable run(Runnable runnable) {
      return runnable;
    }

    private static void processBuckets(Buckets buckets) {
      Stream.<Consumer<Buckets>>of(
        $::equalizeBuckets,
        $::randomizeBuckets
      )
        .parallel()
        .map(consumer -> run(() -> consumer.accept(buckets)))
        .map(Thread::new)
        .forEach(Thread::start)
      ;
    }

    private static void displayBuckets(Buckets buckets) {
      while (true) {
        long nextPrintTime = System.currentTimeMillis() + PRINT_DELAY;
        long curTime;
        while ((curTime = System.currentTimeMillis()) < nextPrintTime) {
          try {
            Thread.sleep(nextPrintTime - curTime);
          }
          catch (InterruptedException e) {}
        }
        Stream.of(buckets)
          .parallel()
          .map(Buckets::getBuckets)
          .map(values -> "Current values: " + getTotal(values) + " " + Arrays.toString(values))
          .forEach(System.out::println)
        ;
      }
    }
  }
}
