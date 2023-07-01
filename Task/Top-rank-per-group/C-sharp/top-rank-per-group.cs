using System;
using System.Collections.Generic;
using System.Linq;

public class Program
{
    class Employee
    {
        public Employee(string name, string id, int salary, string department)
        {
            Name = name;
            Id = id;
            Salary = salary;
            Department = department;
        }

        public string Name { get; private set; }
        public string Id { get; private set; }
        public int Salary { get; private set; }
        public string Department { get; private set; }

        public override string ToString()
        {
            return String.Format("{0, -25}\t{1}\t{2}", Name, Id, Salary);
        }
    }

    private static void Main(string[] args)
    {
        var employees = new List<Employee>
                        {
                            new Employee("Tyler Bennett", "E10297", 32000, "D101"),
                            new Employee("John Rappl", "E21437", 47000, "D050"),
                            new Employee("George Woltman", "E21437", 53500, "D101"),
                            new Employee("Adam Smith", "E21437", 18000, "D202"),
                            new Employee("Claire Buckman", "E39876", 27800, "D202"),
                            new Employee("David McClellan", "E04242", 41500, "D101"),
                            new Employee("Rich Holcomb", "E01234", 49500, "D202"),
                            new Employee("Nathan Adams", "E41298", 21900, "D050"),
                            new Employee("Richard Potter", "E43128", 15900, "D101"),
                            new Employee("David Motsinger", "E27002", 19250, "D202"),
                            new Employee("Tim Sampair", "E03033", 27000, "D101"),
                            new Employee("Kim Arlich", "E10001", 57000, "D190"),
                            new Employee("Timothy Grove", "E16398", 29900, "D190")
                        };

        DisplayTopNPerDepartment(employees, 2);
    }

    static void DisplayTopNPerDepartment(IEnumerable<Employee> employees, int n)
    {
        var topSalariesByDepartment =
            from employee in employees
            group employee by employee.Department
            into g
            select new
                    {
                        Department = g.Key,
                        TopEmployeesBySalary = g.OrderByDescending(e => e.Salary).Take(n)
                    };

        foreach (var x in topSalariesByDepartment)
        {
            Console.WriteLine("Department: " + x.Department);
            foreach (var employee in x.TopEmployeesBySalary)
                Console.WriteLine(employee);
            Console.WriteLine("----------------------------");
        }
    }
}
