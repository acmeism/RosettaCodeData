import java.util.*;

public class RankingMethods {

    final static String[] input = {"44 Solomon", "42 Jason", "42 Errol",
        "41 Garry", "41 Bernard", "41 Barry", "39 Stephen"};

    public static void main(String[] args) {
        int len = input.length;

        Map<String, int[]> map = new TreeMap<>((a, b) -> b.compareTo(a));
        for (int i = 0; i < len; i++) {
            String key = input[i].split("\\s+")[0];
            int[] arr;
            if ((arr = map.get(key)) == null)
                arr = new int[]{i, 0};
            arr[1]++;
            map.put(key, arr);
        }
        int[][] groups = map.values().toArray(new int[map.size()][]);

        standardRanking(len, groups);
        modifiedRanking(len, groups);
        denseRanking(len, groups);
        ordinalRanking(len);
        fractionalRanking(len, groups);
    }

    private static void standardRanking(int len, int[][] groups) {
        System.out.println("\nStandard ranking");
        for (int i = 0, rank = 0, group = 0; i < len; i++) {
            if (group < groups.length && i == groups[group][0]) {
                rank = i + 1;
                group++;
            }
            System.out.printf("%d %s%n", rank, input[i]);
        }
    }

    private static void modifiedRanking(int len, int[][] groups) {
        System.out.println("\nModified ranking");
        for (int i = 0, rank = 0, group = 0; i < len; i++) {
            if (group < groups.length && i == groups[group][0])
                rank += groups[group++][1];
            System.out.printf("%d %s%n", rank, input[i]);
        }
    }

    private static void denseRanking(int len, int[][] groups) {
        System.out.println("\nDense ranking");
        for (int i = 0, rank = 0; i < len; i++) {
            if (rank < groups.length && i == groups[rank][0])
                rank++;
            System.out.printf("%d %s%n", rank, input[i]);
        }
    }

    private static void ordinalRanking(int len) {
        System.out.println("\nOrdinal ranking");
        for (int i = 0; i < len; i++)
            System.out.printf("%d %s%n", i + 1, input[i]);
    }

    private static void fractionalRanking(int len, int[][] groups) {
        System.out.println("\nFractional ranking");
        float rank = 0;
        for (int i = 0, tmp = 0, group = 0; i < len; i++) {
            if (group < groups.length && i == groups[group][0]) {
                tmp += groups[group++][1];
                rank = (i + 1 + tmp) / 2.0F;
            }
            System.out.printf("%2.1f %s%n", rank, input[i]);
        }
    }
}
