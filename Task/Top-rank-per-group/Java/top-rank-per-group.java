import java.io.File;
import java.util.*;

public class TopRankPerGroup {

    private static class Employee {
        final String name;
        final String id;
        final String department;
        final int salary;

        Employee(String[] rec) {
            name = rec[0];
            id = rec[1];
            salary = Integer.parseInt(rec[2]);
            department = rec[3];
        }

        @Override
        public String toString() {
            return String.format("%s %s %d %s", id, name, salary, department);
        }
    }

    public static void main(String[] args) throws Exception {
        int N = args.length > 0 ? Integer.parseInt(args[0]) : 3;

        Map<String, List<Employee>> records = new TreeMap<>();
        try (Scanner sc = new Scanner(new File("data.txt"))) {
            while (sc.hasNextLine()) {
                String[] rec = sc.nextLine().trim().split(", ");

                List<Employee> lst = records.get(rec[3]);
                if (lst == null) {
                    lst = new ArrayList<>();
                    records.put(rec[3], lst);
                }
                lst.add(new Employee(rec));
            }
        }

        records.forEach((key, val) -> {
            System.out.printf("%nDepartment %s%n", key);
            val.stream()
                .sorted((a, b) -> Integer.compare(b.salary, a.salary))
                .limit(N).forEach(System.out::println);
        });
    }
}
