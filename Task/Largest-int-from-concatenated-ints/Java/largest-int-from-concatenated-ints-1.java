import java.util.*;

public class IntConcat {

    private static Comparator<Integer> sorter = new Comparator<Integer>(){
        @Override
        public int compare(Integer o1, Integer o2){
            String o1s = o1.toString();
            String o2s = o2.toString();

            if(o1s.length() == o2s.length()){
                return o2s.compareTo(o1s);
            }

            int mlen = Math.max(o1s.length(), o2s.length());
            while(o1s.length() < mlen * 2) o1s += o1s;
            while(o2s.length() < mlen * 2) o2s += o2s;

            return o2s.compareTo(o1s);
        }
    };

    public static String join(List<?> things){
        String output = "";
        for(Object obj:things){
            output += obj;
        }
        return output;
    }

    public static void main(String[] args){
        List<Integer> ints1 = new ArrayList<Integer>(Arrays.asList(1, 34, 3, 98, 9, 76, 45, 4));

        Collections.sort(ints1, sorter);
        System.out.println(join(ints1));

        List<Integer> ints2 = new ArrayList<Integer>(Arrays.asList(54, 546, 548, 60));

        Collections.sort(ints2, sorter);
        System.out.println(join(ints2));
    }
}
