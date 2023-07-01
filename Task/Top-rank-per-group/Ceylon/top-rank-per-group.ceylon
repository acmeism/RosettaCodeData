class Employee(name, id, salary, dept) {
    shared String name;
    shared String id;
    shared Integer salary;
    shared String dept;

    string => "``name`` ``id`` $``salary``.00 ``dept``";
}

Employee[] employees = [
    Employee("Tyler Bennett", "E10297", 32000, "D101"),
    Employee("John Rappl", "E21437", 47000, "D050"),
    Employee("George Woltman", "E00127", 53500, "D101"),
    Employee("Adam Smith", "E63535", 18000, "D202"),
    Employee("Claire Buckman", "E39876", 27800, "D202"),
    Employee("David McClellan", "E04242", 41500, "D101"),
    Employee("Rich Holcomb", "E01234", 49500, "D202"),
    Employee("Nathan Adams", "E41298", 21900, "D050"),
    Employee("Richard Potter", "E43128", 15900, "D101"),
    Employee("David Motsinger", "E27002", 19250, "D202"),
    Employee("Tim Sampair", "E03033", 27000, "D101"),
    Employee("Kim Arlich", "E10001", 57000, "D190"),
    Employee("Timothy Grove", "E16398", 29900, "D190")
];

"This is the main function."
shared void run() {

    value topRanked = topSalaries(employees, 3);

    for (dept -> staff in topRanked) {
        print(dept);
        for (employee in staff) {
            print("\t``employee``");
        }
    }
}

Map<String, {Employee*}> topSalaries({Employee*} employees, Integer n) => map {
    for (dept -> staff in employees.group(Employee.dept))
    dept -> staff.sort(byDecreasing(Employee.salary)).take(n)
};
