import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.Collectors;

public class UPC {
    private static final int SEVEN = 7;

    private static final Map<String, Integer> LEFT_DIGITS = Map.of(
        "   ## #", 0,
        "  ##  #", 1,
        "  #  ##", 2,
        " #### #", 3,
        " #   ##", 4,
        " ##   #", 5,
        " # ####", 6,
        " ### ##", 7,
        " ## ###", 8,
        "   # ##", 9
    );

    private static final Map<String, Integer> RIGHT_DIGITS = LEFT_DIGITS.entrySet()
        .stream()
        .collect(Collectors.toMap(
            entry -> entry.getKey()
                .replace(' ', 's')
                .replace('#', ' ')
                .replace('s', '#'),
            Map.Entry::getValue
        ));

    private static final String END_SENTINEL = "# #";
    private static final String MID_SENTINEL = " # # ";

    private static void decodeUPC(String input) {
        Function<String, Map.Entry<Boolean, List<Integer>>> decode = (String candidate) -> {
            int pos = 0;
            var part = candidate.substring(pos, pos + END_SENTINEL.length());

            List<Integer> output = new ArrayList<>();
            if (END_SENTINEL.equals(part)) {
                pos += END_SENTINEL.length();
            } else {
                return Map.entry(false, output);
            }

            for (int i = 1; i < SEVEN; i++) {
                part = candidate.substring(pos, pos + SEVEN);
                pos += SEVEN;

                if (LEFT_DIGITS.containsKey(part)) {
                    output.add(LEFT_DIGITS.get(part));
                } else {
                    return Map.entry(false, output);
                }
            }

            part = candidate.substring(pos, pos + MID_SENTINEL.length());
            if (MID_SENTINEL.equals(part)) {
                pos += MID_SENTINEL.length();
            } else {
                return Map.entry(false, output);
            }

            for (int i = 1; i < SEVEN; i++) {
                part = candidate.substring(pos, pos + SEVEN);
                pos += SEVEN;

                if (RIGHT_DIGITS.containsKey(part)) {
                    output.add(RIGHT_DIGITS.get(part));
                } else {
                    return Map.entry(false, output);
                }
            }

            part = candidate.substring(pos, pos + END_SENTINEL.length());
            if (!END_SENTINEL.equals(part)) {
                return Map.entry(false, output);
            }

            int sum = 0;
            for (int i = 0; i < output.size(); i++) {
                if (i % 2 == 0) {
                    sum += 3 * output.get(i);
                } else {
                    sum += output.get(i);
                }
            }
            return Map.entry(sum % 10 == 0, output);
        };

        Consumer<List<Integer>> printList = list -> {
            var it = list.iterator();
            System.out.print('[');
            if (it.hasNext()) {
                System.out.print(it.next());
            }
            while (it.hasNext()) {
                System.out.print(", ");
                System.out.print(it.next());
            }
            System.out.print(']');
        };

        var candidate = input.trim();
        var out = decode.apply(candidate);
        if (out.getKey()) {
            printList.accept(out.getValue());
            System.out.println();
        } else {
            StringBuilder builder = new StringBuilder(candidate);
            builder.reverse();
            out = decode.apply(builder.toString());
            if (out.getKey()) {
                printList.accept(out.getValue());
                System.out.println(" Upside down");
            } else if (out.getValue().size() == 12) {
                System.out.println("Invalid checksum");
            } else {
                System.out.println("Invalid digit(s)");
            }
        }
    }

    public static void main(String[] args) {
        var barcodes = List.of(
            "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
            "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
            "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
            "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
            "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
            "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
            "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
            "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
            "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
            "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
        );
        barcodes.forEach(UPC::decodeUPC);
    }
}
