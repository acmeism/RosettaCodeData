public class Cuboid {
    private double length;
    private double breadth;
    private double height;

    public Cuboid() {
        this.length = 0.0;
        this.breadth = 0.0;
        this.height = 0.0;
    }

    public double getVolume() {
        return this.length * this.breadth * this.height;
    }

    public void setLength(double val) {
        this.length = val;
    }

    public void setBreadth(double val) {
        this.breadth = val;
    }

    public void setHeight(double val) {
        this.height = val;
    }

    public Cuboid add(Cuboid c) {
        Cuboid result = new Cuboid();
        result.length = this.length + c.length;
        result.breadth = this.breadth + c.breadth;
        result.height = this.height + c.height;
        return result;
    }

    public Cuboid subtract(Cuboid c) {
        Cuboid result = new Cuboid();
        result.length = this.length - c.length;
        result.breadth = this.breadth - c.breadth;
        result.height = this.height - c.height;
        return result;
    }

    public static void main(String[] args) {
        Cuboid c1 = new Cuboid();
        Cuboid c2 = new Cuboid();
        Cuboid c3 = new Cuboid();

        c1.setLength(6.0);
        c1.setBreadth(7.0);
        c1.setHeight(5.0);

        c2.setLength(12.0);
        c2.setBreadth(13.0);
        c2.setHeight(10.0);

        double volume = c1.getVolume();
        System.out.println("Volume of 1st cuboid: " + volume);

        volume = c2.getVolume();
        System.out.println("Volume of 2nd cuboid: " + volume);

        c3 = c1.add(c2);
        volume = c3.getVolume();
        System.out.println("Volume of 3rd cuboid after adding: " + volume);

        c3 = c1.subtract(c2);
        volume = c3.getVolume();
        System.out.println("Volume of 3rd cuboid after subtracting: " + volume);
    }
}

