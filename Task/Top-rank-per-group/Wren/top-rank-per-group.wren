import "./dynamic" for Tuple
import "./sort" for Sort, Cmp
import "./seq" for Lst
import "./fmt" for Fmt

var Employee = Tuple.create("Employee", ["name", "id", "salary", "dept"])

var N = 2 // say

var employees = [
    Employee.new("Tyler Bennett", "E10297", 32000, "D101"),
    Employee.new("John Rappl", "E21437", 47000, "D050"),
    Employee.new("George Woltman" , "E00127", 53500, "D101"),
    Employee.new("Adam Smith", "E63535", 18000, "D202"),
    Employee.new("Claire Buckman", "E39876", 27800, "D202"),
    Employee.new("David McClellan", "E04242", 41500, "D101"),
    Employee.new("Rich Holcomb", "E01234", 49500, "D202"),
    Employee.new("Nathan Adams", "E41298", 21900, "D050"),
    Employee.new("Richard Potter", "E43128", 15900, "D101"),
    Employee.new("David Motsinger", "E27002", 19250, "D202"),
    Employee.new("Tim Sampair", "E03033", 27000, "D101"),
    Employee.new("Kim Arlich", "E10001", 57000, "D190"),
    Employee.new("Timothy Grove", "E16398", 29900, "D190")
]
var cmpByDept = Fn.new { |employee1, employee2| Cmp.string.call(employee1.dept, employee2.dept) }
Sort.insertion(employees, cmpByDept)
var groupsByDept = Lst.groups(employees) { |e| e.dept }
System.print("Highest %(N) salaries by department:\n")
for (group in groupsByDept) {
    var dept = group[0]
    var groupEmployees = group[1].map { |i| i[0] }.toList
    var cmpBySalary = Fn.new { |employee1, employee2| Cmp.numDesc.call(employee1.salary, employee2.salary) }
    Sort.insertion(groupEmployees, cmpBySalary)
    var topRanked = groupEmployees.take(N)
    System.print("Dept %(dept) => ")
    topRanked.each { |e| Fmt.print("$-15s $s $d", e.name, e.id, e.salary) }
    System.print()
}
