package org.rosettacode;

import java.util.ArrayList;
import java.util.List;


/**
 * This program applies the logic in the Sum and Product Puzzle for the value
 * provided by systematically applying each requirement to all number pairs in
 * range. Note that the requirements: (x, y different), (x < y), and
 * (x, y > MIN_VALUE) are baked into the loops in run(), sumAddends(), and
 * productFactors(), so do not need a separate test. Also note that to test a
 * solution to this logic puzzle, it is suggested to test the condition with
 * maxSum = 1685 to ensure that both the original solution (4, 13) and the
 * additional solution (4, 61), and only these solutions, are found. Note
 * also that at 1684 only the original solution should be found!
 */
public class SumAndProductPuzzle {
    private final long beginning;
    private final int maxSum;
    private static final int MIN_VALUE = 2;
    private List<int[]> firstConditionExcludes = new ArrayList<>();
    private List<int[]> secondConditionExcludes = new ArrayList<>();

    public static void main(String... args){

        if (args.length == 0){
            new SumAndProductPuzzle(100).run();
            new SumAndProductPuzzle(1684).run();
            new SumAndProductPuzzle(1685).run();
        } else {
            for (String arg : args){
                try{
                    new SumAndProductPuzzle(Integer.valueOf(arg)).run();
                } catch (NumberFormatException e){
                    System.out.println("Please provide only integer arguments. " +
                            "Provided argument " + arg + " was not an integer. " +
                            "Alternatively, calling the program with no arguments " +
                            "will run the puzzle where maximum sum equals 100, 1684, and 1865.");
                }
            }
        }
    }

    public SumAndProductPuzzle(int maxSum){
        this.beginning = System.currentTimeMillis();
        this.maxSum = maxSum;
        System.out.println("Run with maximum sum of " + String.valueOf(maxSum) +
                " started at " + String.valueOf(beginning) + ".");
    }

    public void run(){
        for (int x = MIN_VALUE; x < maxSum - MIN_VALUE; x++){
            for (int y = x + 1; y < maxSum - MIN_VALUE; y++){

                if (isSumNoGreaterThanMax(x,y) &&
                    isSKnowsPCannotKnow(x,y) &&
                    isPKnowsNow(x,y) &&
                    isSKnowsNow(x,y)
                    ){
                    System.out.println("Found solution x is " + String.valueOf(x) + " y is " + String.valueOf(y) +
                            " in " + String.valueOf(System.currentTimeMillis() - beginning) + "ms.");
                }
            }
        }
        System.out.println("Run with maximum sum of " + String.valueOf(maxSum) +
                " ended in " + String.valueOf(System.currentTimeMillis() - beginning) + "ms.");
    }

    public boolean isSumNoGreaterThanMax(int x, int y){
        return x + y <= maxSum;
    }

    public boolean isSKnowsPCannotKnow(int x, int y){

        if (firstConditionExcludes.contains(new int[] {x, y})){
            return false;
        }

        for (int[] addends : sumAddends(x, y)){
            if ( !(productFactors(addends[0], addends[1]).size() > 1) ) {
                firstConditionExcludes.add(new int[] {x, y});
                return false;
            }
        }
        return true;
    }

    public boolean isPKnowsNow(int x, int y){

        if (secondConditionExcludes.contains(new int[] {x, y})){
            return false;
        }

        int countSolutions = 0;
        for (int[] factors : productFactors(x, y)){
            if (isSKnowsPCannotKnow(factors[0], factors[1])){
                countSolutions++;
            }
        }

        if (countSolutions == 1){
            return true;
        } else {
            secondConditionExcludes.add(new int[] {x, y});
            return false;
        }
    }

    public boolean isSKnowsNow(int x, int y){

        int countSolutions = 0;
        for (int[] addends : sumAddends(x, y)){
            if (isPKnowsNow(addends[0], addends[1])){
                countSolutions++;
            }
        }
        return countSolutions == 1;
    }

    public List<int[]> sumAddends(int x, int y){

        List<int[]> list = new ArrayList<>();
        int sum = x + y;

        for (int addend = MIN_VALUE; addend < sum - addend; addend++){
            if (isSumNoGreaterThanMax(addend, sum - addend)){
                list.add(new int[]{addend, sum - addend});
            }
        }
        return list;
    }

    public List<int[]> productFactors(int x, int y){

        List<int[]> list = new ArrayList<>();
        int product = x * y;

        for (int factor = MIN_VALUE; factor < product / factor; factor++){
            if (product % factor == 0){
                if (isSumNoGreaterThanMax(factor, product / factor)){
                    list.add(new int[]{factor, product / factor});
                }
            }
        }
        return list;
    }
}
