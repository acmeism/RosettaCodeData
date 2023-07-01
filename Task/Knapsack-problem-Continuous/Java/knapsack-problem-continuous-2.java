package hu.pj.alg;

import hu.pj.obj.Item;
import java.util.*;

public class ContinuousKnapsack {

    protected List<Item> itemList   = new ArrayList<Item>();
    protected double maxWeight      = 0;
    protected double solutionWeight = 0;
    protected double profit         = 0;
    protected boolean calculated    = false;

    public ContinuousKnapsack() {}

    public ContinuousKnapsack(double _maxWeight) {
        setMaxWeight(_maxWeight);
    }

    public List<Item> calcSolution() {
        int n = itemList.size();

        setInitialStateForCalculation();
        if (n > 0  &&  maxWeight > 0) {
            Collections.sort(itemList);
            for (int i = 0; (maxWeight - solutionWeight) > 0.0  &&  i < n; i++) {
                Item item = itemList.get(i);
                if (item.getWeight() >= (maxWeight - solutionWeight)) {
                    item.setInKnapsack(maxWeight - solutionWeight);
                    solutionWeight = maxWeight;
                    profit += item.getInKnapsack() / item.getWeight() * item.getValue();
                    break;
                } else {
                    item.setInKnapsack(item.getWeight());
                    solutionWeight += item.getInKnapsack();
                    profit += item.getValue();
                }
            }
            calculated = true;
        }

        return itemList;
    }

    // add an item to the item list
    public void add(String name, double weight, double value) {
        if (name.equals(""))
            name = "" + (itemList.size() + 1);
        itemList.add(new Item(name, weight, value));
        setInitialStateForCalculation();
    }

    public double getMaxWeight() {return maxWeight;}
    public double getProfit() {return profit;}
    public double getSolutionWeight() {return solutionWeight;}
    public boolean isCalculated() {return calculated;}

    public void setMaxWeight(double _maxWeight) {
        maxWeight = Math.max(_maxWeight, 0);
    }

    // set the member with name "inKnapsack" by all items:
    private void setInKnapsackByAll(double inKnapsack) {
        for (Item item : itemList)
            item.setInKnapsack(inKnapsack);
    }

    // set the data members of class in the state of starting the calculation:
    protected void setInitialStateForCalculation() {
        setInKnapsackByAll(-0.0001);
        calculated     = false;
        profit         = 0.0;
        solutionWeight = 0.0;
    }

} // class
