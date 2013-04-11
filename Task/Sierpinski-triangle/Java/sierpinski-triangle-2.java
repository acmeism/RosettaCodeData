import java.util.*;

public class Sierpinski
{
    public static List<String> sierpinski(int n)
    {
        List<String> down = Arrays.asList("*");
        String space = " ";
        for (int i = 0; i < n; i++) {
            List<String> newDown = new ArrayList<String>();
            for (String x : down)
                newDown.add(space + x + space);
            for (String x : down)
                newDown.add(x + " " + x);

            down = newDown;
            space += space;
        }
        return down;
    }

    public static void main(String[] args)
    {
        for (String x : sierpinski(4))
            System.out.println(x);
    }
}
