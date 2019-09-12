struct Employee {
  var name: String
  var id: String
  var salary: Int
  var department: String
}

let employees = [
  Employee(name: "Tyler Bennett", id: "E10297", salary: 32000, department: "D101"),
  Employee(name: "John Rappl", id: "E21437", salary: 47000, department: "D050"),
  Employee(name: "George Woltman", id: "E00127", salary: 53500, department: "D101"),
  Employee(name: "Adam Smith", id: "E63535", salary: 18000, department: "D202"),
  Employee(name: "Claire Buckman", id: "E39876", salary: 27800, department: "D202"),
  Employee(name: "David McClellan", id: "E04242", salary: 41500, department: "D101"),
  Employee(name: "Rich Holcomb", id: "E01234", salary: 49500, department: "D202"),
  Employee(name: "Nathan Adams", id: "E41298", salary: 21900, department: "D050"),
  Employee(name: "Richard Potter", id: "E43128", salary: 15900, department: "D101"),
  Employee(name: "David Motsinger", id: "E27002", salary: 19250, department: "D202"),
  Employee(name: "Tim Sampair", id: "E03033", salary: 27000, department: "D101"),
  Employee(name: "Kim Arlich", id: "E10001", salary: 57000, department: "D190"),
  Employee(name: "Timothy Grove", id: "E16398", salary: 29900, department: "D190")
]

func highestSalaries(employees: [Employee], n: Int = 1) -> [String: [Employee]] {
  return employees.reduce(into: [:], {acc, employee in
    guard var cur = acc[employee.department] else {
      acc[employee.department] = [employee]

      return
    }

    if cur.count < n {
      cur.append(employee)
    } else if cur.last!.salary < employee.salary {
      cur[n - 1] = employee
    }

    acc[employee.department] = cur.sorted(by: { $0.salary > $1.salary })
  })
}

for (dept, employees) in highestSalaries(employees: employees, n: 3) {
  let employeeString = employees.map({ "\($0.name): \($0.salary)" }).joined(separator: "\n\t")

  print("\(dept)'s highest paid employees are: \n\t\(employeeString)")
}
