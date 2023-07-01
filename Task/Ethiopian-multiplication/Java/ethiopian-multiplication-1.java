import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
public class Mult{
  public static void main(String[] args){
    Scanner sc = new Scanner(System.in);
    int first = sc.nextInt();
    int second = sc.nextInt();

    if(first < 0){
        first = -first;
        second = -second;
    }

    Map<Integer, Integer> columns = new HashMap<Integer, Integer>();
        columns.put(first, second);
    int sum = isEven(first)? 0 : second;
    do{
      first = halveInt(first);
      second = doubleInt(second);
      columns.put(first, second);
      if(!isEven(first)){
          sum += second;
      }
    }while(first > 1);

    System.out.println(sum);
  }

  public static int doubleInt(int doubleMe){
    return doubleMe << 1; //shift left
  }

  public static int halveInt(int halveMe){
    return halveMe >>> 1; //shift right
  }

  public static boolean isEven(int num){
    return (num & 1) == 0;
  }
}
