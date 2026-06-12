package railwaycircuit;

import static java.util.Arrays.stream;
import java.util.*;
import static java.util.stream.IntStream.range;

public class RailwayCircuit {
    final static int RIGHT = 1, LEFT = -1, STRAIGHT = 0;

    static String normalize(int[] tracks) {
        char[] a = new char[tracks.length];
        for (int i = 0; i < a.length; i++)
            a[i] = "abc".charAt(tracks[i] + 1);

        /* Rotate the array and find the lexicographically lowest order
        to allow the hashmap to weed out duplicate solutions. */
        String norm = new String(a);
        for (int i = 0, len = a.length; i < len; i++) {

            String s = new String(a);
            if (s.compareTo(norm) < 0)
                norm = s;

            char tmp = a[0];
            for (int j = 1; j < a.length; j++)
                a[j - 1] = a[j];
            a[len - 1] = tmp;
        }
        return norm;
    }

    static boolean fullCircleStraight(int[] tracks, int nStraight) {
        if (nStraight == 0)
            return true;

        // do we have the requested number of straight tracks
        if (stream(tracks).filter(i -> i == STRAIGHT).count() != nStraight)
            return false;

        // check symmetry of straight tracks: i and i + 6, i and i + 4
        int[] straight = new int[12];
        for (int i = 0, idx = 0; i < tracks.length && idx >= 0; i++) {
            if (tracks[i] == STRAIGHT)
                straight[idx % 12]++;
            idx += tracks[i];
        }

        return !(range(0, 6).anyMatch(i -> straight[i] != straight[i + 6])
                && range(0, 8).anyMatch(i -> straight[i] != straight[i + 4]));
    }

    static boolean fullCircleRight(int[] tracks) {

        // all tracks need to add up to a multiple of 360
        if (stream(tracks).map(i -> i * 30).sum() % 360 != 0)
            return false;

        // check symmetry of right turns: i and i + 6, i and i + 4
        int[] rTurns = new int[12];
        for (int i = 0, idx = 0; i < tracks.length && idx >= 0; i++) {
            if (tracks[i] == RIGHT)
                rTurns[idx % 12]++;
            idx += tracks[i];
        }

        return !(range(0, 6).anyMatch(i -> rTurns[i] != rTurns[i + 6])
                && range(0, 8).anyMatch(i -> rTurns[i] != rTurns[i + 4]));
    }

    static void circuits(int nCurved, int nStraight) {
        Map<String, int[]> solutions = new HashMap<>();

        PermutationsGen gen = getPermutationsGen(nCurved, nStraight);
        while (gen.hasNext()) {

            int[] tracks = gen.next();

            if (!fullCircleStraight(tracks, nStraight))
                continue;

            if (!fullCircleRight(tracks))
                continue;

            solutions.put(normalize(tracks), tracks.clone());
        }
        report(solutions, nCurved, nStraight);
    }

    static PermutationsGen getPermutationsGen(int nCurved, int nStraight) {
        assert (nCurved + nStraight - 12) % 4 == 0 : "input must be 12 + k * 4";

        int[] trackTypes = new int[]{RIGHT, LEFT};

        if (nStraight != 0) {
            if (nCurved == 12)
                trackTypes = new int[]{RIGHT, STRAIGHT};
            else
                trackTypes = new int[]{RIGHT, LEFT, STRAIGHT};
        }

        return new PermutationsGen(nCurved + nStraight, trackTypes);
    }

    static void report(Map<String, int[]> sol, int numC, int numS) {

        int size = sol.size();
        System.out.printf("%n%d solution(s) for C%d,%d %n", size, numC, numS);

        if (size < 10)
            sol.values().stream().forEach(tracks -> {
                stream(tracks).forEach(i -> System.out.printf("%2d ", i));
                System.out.println();
            });
    }

    public static void main(String[] args) {
        circuits(12, 0);
        circuits(16, 0);
        circuits(20, 0);
        circuits(24, 0);
        circuits(12, 4);
    }
}

class PermutationsGen {
    // not thread safe
    private int[] indices;
    private int[] choices;
    private int[] sequence;
    private int carry;

    PermutationsGen(int numPositions, int[] choices) {
        indices = new int[numPositions];
        sequence = new int[numPositions];
        this.choices = choices;
    }

    int[] next() {
        carry = 1;
        /* The generator skips the first index, so the result will always start
        with a right turn (0) and we avoid clockwise/counter-clockwise
        duplicate solutions. */
        for (int i = 1; i < indices.length && carry > 0; i++) {
            indices[i] += carry;
            carry = 0;

            if (indices[i] == choices.length) {
                carry = 1;
                indices[i] = 0;
            }
        }

        for (int i = 0; i < indices.length; i++)
            sequence[i] = choices[indices[i]];

        return sequence;
    }

    boolean hasNext() {
        return carry != 1;
    }
}
