/*
 * Source https://stackoverflow.com/a/51092690/5520417
 */

package matematicas;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Stack;

/**
 * @author rodri
 *
 */

public class IterativeAckermannMemoryOptimization extends Thread {

  /**
   * Max percentage of free memory that the program will use. Default is 10% since
   * the majority of the used devices are mobile and therefore it is more likely
   * that the user will have more opened applications at the same time than in a
   * desktop device
   */
  private static Double SYSTEM_MEMORY_LIMIT_PERCENTAGE = 0.1;

  /**
   * Attribute of the type IterativeAckermann
   */
  private IterativeAckermann iterativeAckermann;

  /**
   * @param iterativeAckermann
   */
  public IterativeAckermannMemoryOptimization(IterativeAckermann iterativeAckermann) {
    super();
    this.iterativeAckermann = iterativeAckermann;
  }

  /**
   * @return
   */
  public IterativeAckermann getIterativeAckermann() {
    return iterativeAckermann;
  }

  /**
   * @param iterativeAckermann
   */
  public void setIterativeAckermann(IterativeAckermann iterativeAckermann) {
    this.iterativeAckermann = iterativeAckermann;
  }

  public static Double getSystemMemoryLimitPercentage() {
    return SYSTEM_MEMORY_LIMIT_PERCENTAGE;
  }

  /**
   * Principal method of the thread. Checks that the memory used doesn't exceed or
   * equal the limit, and informs the user when that happens.
   */
  @Override
  public void run() {
    String operating_system = System.getProperty("os.name").toLowerCase();
    if ( operating_system.equals("windows") || operating_system.equals("linux") || operating_system.equals("macintosh") ) {
      SYSTEM_MEMORY_LIMIT_PERCENTAGE = 0.25;
    }

    while ( iterativeAckermann.getConsumed_heap() >= SYSTEM_MEMORY_LIMIT_PERCENTAGE * Runtime.getRuntime().freeMemory() ) {
      try {
        wait();
      }
      catch ( InterruptedException e ) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    if ( ! iterativeAckermann.isAlive() )
      iterativeAckermann.start();
    else
      notifyAll();

  }

}


public class IterativeAckermann extends Thread {

  /*
   * Adjust parameters conveniently
   */
  /**
   *
   */
  private static final int HASH_SIZE_LIMIT = 636;

  /**
   *
   */
  private BigInteger m;

  /**
   *
   */
  private BigInteger n;

  /**
   *
   */
  private Integer hash_size;

  /**
   *
   */
  private Long consumed_heap;

  /**
   * @param m
   * @param n
   * @param invalid
   * @param invalid2
   */
  public IterativeAckermann(BigInteger m, BigInteger n, Integer invalid, Long invalid2) {
    super();
    this.m = m;
    this.n = n;
    this.hash_size = invalid;
    this.consumed_heap = invalid2;
  }

  /**
   *
   */
  public IterativeAckermann() {
    // TODO Auto-generated constructor stub
    super();
    m = null;
    n = null;
    hash_size = 0;
    consumed_heap = 0l;
  }

  /**
   * @return
   */
  public static BigInteger getLimit() {
    return LIMIT;
  }

  /**
   * @author rodri
   *
   * @param <T1>
   * @param <T2>
   */
  /**
   * @author rodri
   *
   * @param <T1>
   * @param <T2>
   */
  static class Pair<T1, T2> {

    /**
     *
     */
    /**
     *
     */
    T1 x;

    /**
     *
     */
    /**
     *
     */
    T2 y;

    /**
     * @param x_
     * @param y_
     */
    /**
     * @param x_
     * @param y_
     */
    Pair(T1 x_, T2 y_) {
      x = x_;
      y = y_;
    }

    /**
     *
     */
    /**
     *
     */
    @Override
    public int hashCode() {
      return x.hashCode() ^ y.hashCode();
    }

    /**
     *
     */
    /**
     *
     */
    @Override
    public boolean equals(Object o_) {

      if ( o_ == null ) {
        return false;
      }
      if ( o_.getClass() != this.getClass() ) {
        return false;
      }
      Pair<?, ?> o = (Pair<?, ?>) o_;
      return x.equals(o.x) && y.equals(o.y);
    }
  }

  /**
   *
   */
  private static final BigInteger LIMIT = new BigInteger("6");

  /**
   * @param m
   * @param n
   * @return
   */

  /**
   *
   */
  @Override
  public void run() {
    while ( hash_size >= HASH_SIZE_LIMIT ) {
      try {
        this.wait();
      }
      catch ( InterruptedException e ) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
    }
    for ( BigInteger i = BigInteger.ZERO; i.compareTo(LIMIT) == - 1; i = i.add(BigInteger.ONE) ) {
      for ( BigInteger j = BigInteger.ZERO; j.compareTo(LIMIT) == - 1; j = j.add(BigInteger.ONE) ) {
        IterativeAckermann iterativeAckermann = new IterativeAckermann(i, j, null, null);
        System.out.printf("Ackmermann(%d, %d) = %d\n", i, j, iterativeAckermann.iterative_ackermann(i, j));

      }
    }
  }

  /**
   * @return
   */
  public BigInteger getM() {
    return m;
  }

  /**
   * @param m
   */
  public void setM(BigInteger m) {
    this.m = m;
  }

  /**
   * @return
   */
  public BigInteger getN() {
    return n;
  }

  /**
   * @param n
   */
  public void setN(BigInteger n) {
    this.n = n;
  }

  /**
   * @return
   */
  public Integer getHash_size() {
    return hash_size;
  }

  /**
   * @param hash_size
   */
  public void setHash_size(Integer hash_size) {
    this.hash_size = hash_size;
  }

  /**
   * @return
   */
  public Long getConsumed_heap() {
    return consumed_heap;
  }

  /**
   * @param consumed_heap
   */
  public void setConsumed_heap(Long consumed_heap) {
    this.consumed_heap = consumed_heap;
  }

  /**
   * @param m
   * @param n
   * @return
   */
  public BigInteger iterative_ackermann(BigInteger m, BigInteger n) {
    if ( m.compareTo(BigInteger.ZERO) != - 1 && m.compareTo(BigInteger.ZERO) != - 1 )
      try {
        HashMap<Pair<BigInteger, BigInteger>, BigInteger> solved_set = new HashMap<Pair<BigInteger, BigInteger>, BigInteger>(900000);
        Stack<Pair<BigInteger, BigInteger>> to_solve = new Stack<Pair<BigInteger, BigInteger>>();
        to_solve.push(new Pair<BigInteger, BigInteger>(m, n));

        while ( ! to_solve.isEmpty() ) {
          Pair<BigInteger, BigInteger> head = to_solve.peek();
          if ( head.x.equals(BigInteger.ZERO) ) {
            solved_set.put(head, head.y.add(BigInteger.ONE));
            to_solve.pop();
          }
          else if ( head.y.equals(BigInteger.ZERO) ) {
            Pair<BigInteger, BigInteger> next = new Pair<BigInteger, BigInteger>(head.x.subtract(BigInteger.ONE), BigInteger.ONE);
            BigInteger result = solved_set.get(next);
            if ( result == null ) {
              to_solve.push(next);
            }
            else {
              solved_set.put(head, result);
              to_solve.pop();
            }
          }
          else {
            Pair<BigInteger, BigInteger> next0 = new Pair<BigInteger, BigInteger>(head.x, head.y.subtract(BigInteger.ONE));
            BigInteger result0 = solved_set.get(next0);
            if ( result0 == null ) {
              to_solve.push(next0);
            }
            else {
              Pair<BigInteger, BigInteger> next = new Pair<BigInteger, BigInteger>(head.x.subtract(BigInteger.ONE), result0);
              BigInteger result = solved_set.get(next);
              if ( result == null ) {
                to_solve.push(next);
              }
              else {
                solved_set.put(head, result);
                to_solve.pop();
              }
            }
          }
        }
        this.hash_size = solved_set.size();
        System.out.println("Hash Size: " + hash_size);
        consumed_heap = (Runtime.getRuntime().totalMemory() / (1024 * 1024));
        System.out.println("Consumed Heap: " + consumed_heap + "m");
        setHash_size(hash_size);
        setConsumed_heap(consumed_heap);
        return solved_set.get(new Pair<BigInteger, BigInteger>(m, n));

      }
      catch ( OutOfMemoryError e ) {
        // TODO: handle exception
        e.printStackTrace();
      }
    throw new IllegalArgumentException("The arguments must be non-negative integers.");
  }

  /**
   * @param args
   */
  /**
   * @param args
   */
  public static void main(String[] args) {
    IterativeAckermannMemoryOptimization iterative_ackermann_memory_optimization = new IterativeAckermannMemoryOptimization(
        new IterativeAckermann());
    iterative_ackermann_memory_optimization.start();
  }
}
