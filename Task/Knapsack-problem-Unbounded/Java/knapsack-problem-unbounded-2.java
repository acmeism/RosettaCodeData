package hu.pj.obj;

public class Item {
    protected String name = "";
    protected int value = 0;
    protected double weight = 0;
    protected double volume = 0;

    public Item() {
    }

    public Item(String name, int value, double weight, double volume) {
        setName(name);
        setValue(value);
        setWeight(weight);
        setVolume(volume);
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = Math.max(value, 0);
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = Math.max(weight, 0);
    }

    public double getVolume() {
        return volume;
    }

    public void setVolume(double volume) {
        this.volume = Math.max(volume, 0);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

} // class
