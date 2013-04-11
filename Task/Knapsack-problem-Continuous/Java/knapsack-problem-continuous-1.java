package hu.pj.alg.test;

import hu.pj.alg.ContinuousKnapsack;
import hu.pj.obj.Item;
import java.util.*;
import java.text.*;

public class ContinousKnapsackForRobber {
    final private double tolerance = 0.0005;

    public ContinousKnapsackForRobber() {
        ContinuousKnapsack cok = new ContinuousKnapsack(15); // 15 kg

        // making the list of items that you want to bring
        cok.add("beef",     3.8, 36); // marhahús
        cok.add("pork",     5.4, 43); // disznóhús
        cok.add("ham",      3.6, 90); // sonka
        cok.add("greaves",  2.4, 45); // tepertő
        cok.add("flitch",   4.0, 30); // oldalas
        cok.add("brawn",    2.5, 56); // disznósajt
        cok.add("welt",     3.7, 67); // hurka
        cok.add("salami",   3.0, 95); // szalámi
        cok.add("sausage",  5.9, 98); // kolbász

        // calculate the solution:
        List<Item> itemList = cok.calcSolution();

        // write out the solution in the standard output
        if (cok.isCalculated()) {
            NumberFormat nf  = NumberFormat.getInstance();

            System.out.println(
                "Maximal weight           = " +
                nf.format(cok.getMaxWeight()) + " kg"
            );
            System.out.println(
                "Total weight of solution = " +
                nf.format(cok.getSolutionWeight()) + " kg"
            );
            System.out.println(
                "Total value (profit)     = " +
                nf.format(cok.getProfit())
            );
            System.out.println();
            System.out.println(
                "You can carry the following materials " +
                "in the knapsack:"
            );
            for (Item item : itemList) {
                if (item.getInKnapsack() > tolerance) {
                    System.out.format(
                        "%1$-10s %2$-15s %3$-15s \n",
                        nf.format(item.getInKnapsack()) + " kg ",
                        item.getName(),
                        "(value = " + nf.format(item.getInKnapsack() *
                                                (item.getValue() / item.getWeight())) + ")"
                    );
                }
            }
        } else {
            System.out.println(
                "The problem is not solved. " +
                "Maybe you gave wrong data."
            );
        }

    }

    public static void main(String[] args) {
        new ContinousKnapsackForRobber();
    }

} // class
