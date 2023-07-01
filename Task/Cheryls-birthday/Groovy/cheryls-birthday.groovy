import java.time.Month

class Main {
    private static class Birthday {
        private Month month
        private int day

        Birthday(Month month, int day) {
            this.month = month
            this.day = day
        }

        Month getMonth() {
            return month
        }

        int getDay() {
            return day
        }

        @Override
        String toString() {
            return month.toString() + " " + day
        }
    }

    static void main(String[] args) {
        List<Birthday> choices = [
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
        ]
        println("There are ${choices.size()} candidates remaining.")

        // The month cannot have a unique day because Albert knows the month, and knows that Bernard does not know the answer
        Set<Birthday> uniqueMonths = choices.groupBy { it.getDay() }
                .values()
                .findAll() { it.size() == 1 }
                .flatten()
                .collect { ((Birthday) it).getMonth() }
                .toSet() as Set<Birthday>
        def f1List = choices.findAll { !uniqueMonths.contains(it.getMonth()) }
        println("There are ${f1List.size()} candidates remaining.")

        // Bernard now knows the answer, so the day must be unique within the remaining choices
        List<Birthday> f2List = f1List.groupBy { it.getDay() }
                .values()
                .findAll { it.size() == 1 }
                .flatten()
                .toList() as List<Birthday>
        println("There are ${f2List.size()} candidates remaining.")

        // Albert knows the answer too, so the month must be unique within the remaining choices
        List<Birthday> f3List = f2List.groupBy { it.getMonth() }
                .values()
                .findAll { it.size() == 1 }
                .flatten()
                .toList() as List<Birthday>
        println("There are ${f3List.size()} candidates remaining.")

        if (f3List.size() == 1) {
            println("Cheryl's birthday is ${f3List.head()}")
        } else {
            System.out.println("No unique choice found")
        }
    }
}
