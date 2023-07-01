public class TestIntegerWithHistory {

    public static void main(String[] args) {

        //creating and setting three different values
        IntegerWithHistory i = new IntegerWithHistory(3);
        i.set(42);
        i.set(7);

        //looking at current value and history
        System.out.println("The current value of i is :" + i.get());
        System.out.println("The history of i is :" + i.getHistory());

        //demonstrating rollback
        System.out.println("Rolling back:");
        System.out.println("returns what was the current value: " + i.rollback());
        System.out.println("after rollback: " + i.get());
        System.out.println("returns what was the current value: " + i.rollback());
        System.out.println("after rollback: " + i.get());
        System.out.println("Rolling back only works to the original value: " + i.rollback());
        System.out.println("Rolling back only works to the original value: " + i.rollback());
        System.out.println("So there is no way to 'null' the variable: " + i.get());

    }
}
