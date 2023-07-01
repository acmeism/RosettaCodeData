package hu.pj.alg.test;

import hu.pj.alg.ZeroOneKnapsack;
import hu.pj.obj.Item;
import java.util.*;
import java.text.*;

public class ZeroOneKnapsackForTourists {

    public ZeroOneKnapsackForTourists() {
        ZeroOneKnapsack zok = new ZeroOneKnapsack(400); // 400 dkg = 400 dag = 4 kg

        // making the list of items that you want to bring
        zok.add("map", 9, 150);
        zok.add("compass", 13, 35);
        zok.add("water", 153, 200);
        zok.add("sandwich", 50, 160);
        zok.add("glucose", 15, 60);
        zok.add("tin", 68, 45);
        zok.add("banana", 27, 60);
        zok.add("apple", 39, 40);
        zok.add("cheese", 23, 30);
        zok.add("beer", 52, 10);
        zok.add("suntan cream", 11, 70);
        zok.add("camera", 32, 30);
        zok.add("t-shirt", 24, 15);
        zok.add("trousers", 48, 10);
        zok.add("umbrella", 73, 40);
        zok.add("waterproof trousers", 42, 70);
        zok.add("waterproof overclothes", 43, 75);
        zok.add("note-case", 22, 80);
        zok.add("sunglasses", 7, 20);
        zok.add("towel", 18, 12);
        zok.add("socks", 4, 50);
        zok.add("book", 30, 10);

        // calculate the solution:
        List<Item> itemList = zok.calcSolution();

        // write out the solution in the standard output
        if (zok.isCalculated()) {
            NumberFormat nf  = NumberFormat.getInstance();

            System.out.println(
                "Maximal weight           = " +
                nf.format(zok.getMaxWeight() / 100.0) + " kg"
            );
            System.out.println(
                "Total weight of solution = " +
                nf.format(zok.getSolutionWeight() / 100.0) + " kg"
            );
            System.out.println(
                "Total value              = " +
                zok.getProfit()
            );
            System.out.println();
            System.out.println(
                "You can carry the following materials " +
                "in the knapsack:"
            );
            for (Item item : itemList) {
                if (item.getInKnapsack() == 1) {
                    System.out.format(
                        "%1$-23s %2$-3s %3$-5s %4$-15s \n",
                        item.getName(),
                        item.getWeight(), "dag  ",
                        "(value = " + item.getValue() + ")"
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
        new ZeroOneKnapsackForTourists();
    }

} // class
