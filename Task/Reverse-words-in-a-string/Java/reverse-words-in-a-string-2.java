package string;

import static java.util.Arrays.stream;

public interface ReverseWords {
  public static final String[] LINES = {
    " ----------- Ice and Fire ----------- ",
    "                                      ",
    " fire, in end will world the say Some ",
    " ice. in say Some                     ",
    " desire of tasted I've what From      ",
    " fire. favor who those with hold I    ",
    "                                      ",
    " ... elided paragraph last ...        ",
    " Frost Robert ----------------------- "
  };

  public static String[] reverseWords(String[] lines) {
    return stream(lines)
      .parallel()
      .map(l -> l.split("\\s"))
      .map(ws -> stream(ws)
        .parallel()
        .map(w -> " " + w)
        .reduce(
          "",
          (w1, w2) -> w2 + w1
        )
      )
      .toArray(String[]::new)
    ;
  }

  public static void main(String... arguments) {
    stream(reverseWords(LINES))
      .forEach(System.out::println)
    ;
  }
}
