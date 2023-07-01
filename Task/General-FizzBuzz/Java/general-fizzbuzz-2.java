import java.util.stream.*;
import java.util.function.*;
import java.util.*;
public class fizzbuzz_general {
    /**
     * To run: java fizzbuzz_general.java 3=Fizz 5=Buzz 7=Baxx 100
     *
     */
    public static void main(String[] args) {
        Function<String[],Function<Integer,String>> make_cycle_function =
              parts -> j -> j%(Integer.parseInt(parts[0]))==0?parts[1]:"";
        List<Function<Integer,String>> cycle_functions = Stream.of(args)
                     .map(arg -> arg.split("="))
                     .filter(parts->parts.length==2)
                     .map(make_cycle_function::apply)
                     .collect(Collectors.toList());
        Function<Integer,String> moduloTesters = i -> cycle_functions.stream()
                                   .map(fcn->fcn.apply(i))
                                   .collect(Collectors.joining());
        BiFunction<Integer,String,String> formatter =
                    (i,printThis) -> "".equals(printThis)?Integer.toString(i):printThis;
        Function<Integer,String> fizzBuzz = i -> formatter.apply(i,moduloTesters.apply(i));

        IntStream.rangeClosed(0,Integer.parseInt(args[args.length-1]))
           .mapToObj(Integer::valueOf)
           .map(fizzBuzz::apply)
           .forEach(System.out::println);
    }
}
