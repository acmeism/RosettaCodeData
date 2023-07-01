public class TestVolitileClass throws Exception{
   public static void main(String[] args){
      VolatileClass vc = new VolatileClass();
      vc.mutex.acquire(); //will wait automatically if another class has the mutex
                          //can be interrupted similarly to a Thread
                          //use acquireUninterruptibly() to avoid that
      vc.needsToBeSynched();
      vc.mutex.release();
   }
}
