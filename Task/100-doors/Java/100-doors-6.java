public class Doors{
   public static void main(String[] args){
      int i;		
      for(i = 1; i < 101; i++){
         double sqrt = Math.sqrt(i);
         if(sqrt != (int)sqrt){
            System.out.println("Door " + i + " is closed");
         }else{
            System.out.println("Door " + i + " is open");
         }
      }
   } 	
}
