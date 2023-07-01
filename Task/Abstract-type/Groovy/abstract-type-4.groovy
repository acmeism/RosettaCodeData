public class Concrete1 implements Interface {
    public int method1(double value) { value as int }
    public int method2(String name) { (! name) ? 0 : name.toList().collect { it as char }.sum() }
    public int add(int a, int b) { a + b }
}

public class Concrete2 extends Abstract1 {
    public int methodA(Date value) { value.toCalendar()[Calendar.DAY_OF_YEAR] }
    protected int methodB(String name) { (! name) ? 0 : name.toList().collect { it as char }.sum() }
}

public class Concrete3 extends Abstract2 {
    public int method1(double value) { value as int }
    public int method2(String name) { (! name) ? 0 : name.toList().collect { it as char }.sum() }
}
