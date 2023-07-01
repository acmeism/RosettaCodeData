import java.time.Month;
import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class Main {
    private static class Birthday {
        private Month month;
        private int day;

        public Birthday(Month month, int day) {
            this.month = month;
            this.day = day;
        }

        public Month getMonth() {
            return month;
        }

        public int getDay() {
            return day;
        }

        @Override
        public String toString() {
            return month + " " + day;
        }
    }

    public static void main(String[] args) {
        List<Birthday> choices = List.of(
            new Birthday(Month.MAY, 15),
            new Birthday(Month.MAY, 16),
            new Birthday(Month.MAY, 19),
            new Birthday(Month.JUNE, 17),
            new Birthday(Month.JUNE, 18),
            new Birthday(Month.JULY, 14),
            new Birthday(Month.JULY, 16),
            new Birthday(Month.AUGUST, 14),
            new Birthday(Month.AUGUST, 15),
            new Birthday(Month.AUGUST, 17)
        );
        System.out.printf("There are %d candidates remaining.\n", choices.size());

        // The month cannot have a unique day because Albert knows the month, and knows that Bernard does not know the answer
        Set<Month> uniqueMonths = choices.stream()
            .collect(Collectors.groupingBy(Birthday::getDay))
            .values()
            .stream()
            .filter(g -> g.size() == 1)
            .flatMap(Collection::stream)
            .map(Birthday::getMonth)
            .collect(Collectors.toSet());
        List<Birthday> f1List = choices.stream()
            .filter(birthday -> !uniqueMonths.contains(birthday.month))
            .collect(Collectors.toList());
        System.out.printf("There are %d candidates remaining.\n", f1List.size());

        // Bernard now knows the answer, so the day must be unique within the remaining choices
        List<Birthday> f2List = f1List.stream()
            .collect(Collectors.groupingBy(Birthday::getDay))
            .values()
            .stream()
            .filter(g -> g.size() == 1)
            .flatMap(Collection::stream)
            .collect(Collectors.toList());
        System.out.printf("There are %d candidates remaining.\n", f2List.size());

        // Albert knows the answer too, so the month must be unique within the remaining choices
        List<Birthday> f3List = f2List.stream()
            .collect(Collectors.groupingBy(Birthday::getMonth))
            .values()
            .stream()
            .filter(g -> g.size() == 1)
            .flatMap(Collection::stream)
            .collect(Collectors.toList());
        System.out.printf("There are %d candidates remaining.\n", f3List.size());

        if (f3List.size() == 1) {
            System.out.printf("Cheryl's birthday is %s\n", f3List.get(0));
        } else {
            System.out.println("No unique choice found");
        }
    }
}
