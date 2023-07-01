class Abundant {
    static List<Integer> divisors(int n) {
        List<Integer> divs = new ArrayList<>()
        divs.add(1)
        List<Integer> divs2 = new ArrayList<>()

        int i = 2
        while (i * i < n) {
            if (n % i == 0) {
                int j = (int) (n / i)
                divs.add(i)
                if (i != j) {
                    divs2.add(j)
                }
            }
            i++
        }

        Collections.reverse(divs2)
        divs.addAll(divs2)
        return divs
    }

    static int abundantOdd(int searchFrom, int countFrom, int countTo, boolean printOne) {
        int count = countFrom
        int n = searchFrom

        while (count < countTo) {
            List<Integer> divs = divisors(n)
            int tot = divs.stream().reduce(Integer.&sum).orElse(0)

            if (tot > n) {
                count++
                if (!printOne || count >= countTo) {
                    String s = divs.stream()
                            .map(Integer.&toString)
                            .reduce { a, b -> a + " + " + b }
                            .orElse("")
                    if (printOne) {
                        System.out.printf("%d < %s = %d\n", n, s, tot)
                    } else {
                        System.out.printf("%2d. %5d < %s = %d\n", count, n, s, tot)
                    }
                }
            }

            n += 2
        }

        return n
    }

    static void main(String[] args) {
        int max = 25

        System.out.printf("The first %d abundant odd numbers are:\n", max)
        int n = abundantOdd(1, 0, 25, false)

        System.out.println("\nThe one thousandth abundant odd number is:")
        abundantOdd(n, 25, 1000, true)

        System.out.println("\nThe first abundant odd number above one billion is:")
        abundantOdd((int) (1e9 + 1), 0, 1, true)
    }
}
