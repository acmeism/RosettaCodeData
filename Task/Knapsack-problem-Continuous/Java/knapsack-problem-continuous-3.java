package hu.pj.obj;

public class Item implements Comparable {

    protected String name       = "";
    protected double weight     = 0;
    protected double value      = 0;
    protected double inKnapsack = 0; // the weight of item in solution

    public Item() {}

    public Item(Item item) {
        setName(item.name);
        setWeight(item.weight);
        setValue(item.value);
    }

    public Item(double _weight, double _value) {
        setWeight(_weight);
        setValue(_value);
    }

    public Item(String _name, double _weight, double _value) {
        setName(_name);
        setWeight(_weight);
        setValue(_value);
    }

    public void setName(String _name) {name = _name;}
    public void setWeight(double _weight) {weight = Math.max(_weight, 0);}
    public void setValue(double _value) {value = Math.max(_value, 0);}

    public void setInKnapsack(double _inKnapsack) {
        inKnapsack = Math.max(_inKnapsack, 0);
    }

    public void checkMembers() {
        setWeight(weight);
        setValue(value);
        setInKnapsack(inKnapsack);
    }

    public String getName() {return name;}
    public double getWeight() {return weight;}
    public double getValue() {return value;}
    public double getInKnapsack() {return inKnapsack;}

    // implementing of Comparable interface:
    public int compareTo(Object item) {
        int result = 0;
        Item i2 = (Item)item;
        double rate1 = value / weight;
        double rate2 = i2.value / i2.weight;
        if (rate1 > rate2) result = -1;  // if greater, put it previously
        else if (rate1 < rate2) result = 1;
        return result;
    }

} // class
