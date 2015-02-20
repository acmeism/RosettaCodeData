import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Fractran{

   public static void main(String []args){

       new Fractran("17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1", 2);
   }
   final int limit = 15;


   Vector<Integer> num = new Vector<>();
   Vector<Integer> den = new Vector<>();
   public Fractran(String prog, Integer val){
      compile(prog);
      dump();
      exec(2);
    }


   void compile(String prog){
      Pattern regexp = Pattern.compile("\\s*(\\d*)\\s*\\/\\s*(\\d*)\\s*(.*)");
      Matcher matcher = regexp.matcher(prog);
      while(matcher.find()){
         num.add(Integer.parseInt(matcher.group(1)));
         den.add(Integer.parseInt(matcher.group(2)));
         matcher = regexp.matcher(matcher.group(3));
      }
   }

   void exec(Integer val){
       int n = 0;
       while(val != null && n<limit){
           System.out.println(n+": "+val);
           val = step(val);
           n++;
       }
   }
   Integer step(int val){
       int i=0;
       while(i<den.size() && val%den.get(i) != 0) i++;
       if(i<den.size())
           return num.get(i)*val/den.get(i);
       return null;
   }

   void dump(){
       for(int i=0; i<den.size(); i++)
           System.out.print(num.get(i)+"/"+den.get(i)+" ");
       System.out.println();
   }
}
