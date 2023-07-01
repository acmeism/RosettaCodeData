import java.util.Scanner;
import java.util.ArrayList;

public class Sub{
    private static int[] indices;

    public static void main(String[] args){
        ArrayList<Long> array= new ArrayList<Long>(); //the main set
        Scanner in = new Scanner(System.in);
        while(in.hasNextLong()) array.add(in.nextLong());
        long highSum= Long.MIN_VALUE;//start the sum at the lowest possible value
        ArrayList<Long> highSet= new ArrayList<Long>();
        //loop through all possible subarray sizes including 0
        for(int subSize= 0;subSize<= array.size();subSize++){
            indices= new int[subSize];
            for(int i= 0;i< subSize;i++) indices[i]= i;
            do{
                long sum= 0;//this subarray sum variable
                ArrayList<Long> temp= new ArrayList<Long>();//this subarray
                //sum it and save it
                for(long index:indices) {sum+= array.get(index); temp.add(array.get(index));}
                if(sum > highSum){//if we found a higher sum
                    highSet= temp;    //keep track of it
                    highSum= sum;
                }
            }while(nextIndices(array));//while we haven't tested all subarrays
        }
        System.out.println("Sum: " + highSum + "\nSet: " +
        		highSet);
    }
    /**
     * Computes the next set of choices from the previous. The
     * algorithm tries to increment the index of the final choice
     * first. Should that fail (index goes out of bounds), it
     * tries to increment the next-to-the-last index, and resets
     * the last index to one more than the next-to-the-last.
     * Should this fail the algorithm keeps starting at an earlier
     * choice until it runs off the start of the choice list without
     * Finding a legal set of indices for all the choices.
     *
     * @return true unless all choice sets have been exhausted.
     * @author James Heliotis
     */

    private static boolean nextIndices(ArrayList<Long> a) {
        for(int i= indices.length-1;i >= 0;--i){
            indices[i]++;
            for(int j=i+1;j < indices.length;++j){
                indices[j]= indices[j - 1] + 1;//reset the last failed try
            }
            if(indices[indices.length - 1] < a.size()){//if this try went out of bounds
                return true;
            }
        }
        return false;
    }
}
