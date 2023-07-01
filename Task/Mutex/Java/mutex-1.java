import java.util.concurrent.Semaphore;

public class VolatileClass{
   public Semaphore mutex = new Semaphore(1); //also a "fair" boolean may be passed which,
                                              //when true, queues requests for the lock
   public void needsToBeSynched(){
      //...
   }
   //delegate methods could be added for acquiring and releasing the mutex
}
