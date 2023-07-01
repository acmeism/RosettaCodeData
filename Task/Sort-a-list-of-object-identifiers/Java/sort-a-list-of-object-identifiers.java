package com.rosettacode;

import java.util.Comparator;
import java.util.stream.Stream;

public class OIDListSorting {

    public static void main(String[] args) {

        final String dot = "\\.";

        final Comparator<String> oids_comparator = (o1, o2) -> {
            final String[] o1Numbers = o1.split(dot), o2Numbers = o2.split(dot);
            for (int i = 0; ; i++) {
                if (i == o1Numbers.length && i == o2Numbers.length)
                    return 0;
                if (i == o1Numbers.length)
                    return -1;
                if (i == o2Numbers.length)
                    return 1;
                final int nextO1Number = Integer.valueOf(o1Numbers[i]), nextO2Number = Integer.valueOf(o2Numbers[i]);
                final int result = Integer.compare(nextO1Number, nextO2Number);
                if (result != 0)
                    return result;
            }
        };

        Stream.of("1.3.6.1.4.1.11.2.17.19.3.4.0.10", "1.3.6.1.4.1.11.2.17.5.2.0.79", "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
                  "1.3.6.1.4.1.11150.3.4.0.1", "1.3.6.1.4.1.11.2.17.19.3.4.0.1", "1.3.6.1.4.1.11150.3.4.0")
                .sorted(oids_comparator)
                .forEach(System.out::println);
    }
}
