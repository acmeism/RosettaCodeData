import java.util.Locale;

public class Test {

    public static void main(String[] args) {
        System.out.println(new Vec2(5, 7).add(new Vec2(2, 3)));
        System.out.println(new Vec2(5, 7).sub(new Vec2(2, 3)));
        System.out.println(new Vec2(5, 7).mult(11));
        System.out.println(new Vec2(5, 7).div(2));
    }
}

class Vec2 {
    final double x, y;

    Vec2(double x, double y) {
        this.x = x;
        this.y = y;
    }

    Vec2 add(Vec2 v) {
        return new Vec2(x + v.x, y + v.y);
    }

    Vec2 sub(Vec2 v) {
        return new Vec2(x - v.x, y - v.y);
    }

    Vec2 div(double val) {
        return new Vec2(x / val, y / val);
    }

    Vec2 mult(double val) {
        return new Vec2(x * val, y * val);
    }

    @Override
    public String toString() {
        return String.format(Locale.US, "[%s, %s]", x, y);
    }
}
