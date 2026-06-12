import java.util.*;

public class RandomShuffle {
    public static void main(String[] args) {
        Random rand = new Random();
        List<Integer> list = new ArrayList<>();
        for (int j = 1; j <= 20; ++j)
            list.add(j);
        Collections.shuffle(list, rand);
        System.out.println(list);
    }
}
