module meteredconcurrency ;
import std.stdio ;
import std.thread ;
import std.c.time ;

class Semaphore {
  private int lockCnt, maxCnt ;
  this(int count) { maxCnt = lockCnt = count ;}
  void acquire() {
    if(lockCnt < 0 || maxCnt <= 0)
      throw new Exception("Negative Lock or Zero init. Lock") ;
    while(lockCnt == 0)
      Thread.getThis.yield ; // let other threads release lock
    synchronized lockCnt-- ;
  }
  void release() {
    synchronized
      if (lockCnt < maxCnt)
        lockCnt++ ;
      else
        throw new Exception("Release lock before acquire") ;
  }
  int getCnt() { synchronized return lockCnt ; }
}

class Worker : Thread {
  private static int Id = 0 ;
  private Semaphore lock ;
  private int myId ;
  this (Semaphore l) { super() ; lock = l ; myId = Id++ ; }
  override int run() {
    lock.acquire ;
    writefln("Worker %d got a lock(%d left).", myId, lock.getCnt) ;
    msleep(2000) ;  // wait 2.0 sec
    lock.release ;
    writefln("Worker %d released a lock(%d left).", myId, lock.getCnt) ;
    return 0 ;
  }
}

void main() {
  Worker[10] crew ;
  Semaphore lock = new Semaphore(4) ;

  foreach(inout c ; crew)
    (c = new Worker(lock)).start ;
  foreach(inout c ; crew)
    c.wait ;
}
