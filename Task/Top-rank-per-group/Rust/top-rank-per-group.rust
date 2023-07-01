#[derive(Debug)]
struct Employee<S> {
    // Allow S to be any suitable string representation
    id: S,
    name: S,
    department: S,
    salary: u32,
}

impl<S> Employee<S> {
    fn new(name: S, id: S, salary: u32, department: S) -> Self {
        Self {
            id,
            name,
            department,
            salary,
        }
    }
}

#[rustfmt::skip]
fn load_data() -> Vec<Employee<&'static str>> {
    vec![
        Employee::new("Tyler Bennett",    "E10297", 32000, "D101"),
        Employee::new("John Rappl",       "E21437", 47000, "D050"),
        Employee::new("George Woltman",   "E00127", 53500, "D101"),
        Employee::new("Adam Smith",       "E63535", 18000, "D202"),
        Employee::new("Claire Buckman",   "E39876", 27800, "D202"),
        Employee::new("David McClellan",  "E04242", 41500, "D101"),
        Employee::new("Rich Holcomb",     "E01234", 49500, "D202"),
        Employee::new("Nathan Adams",     "E41298", 21900, "D050"),
        Employee::new("Richard Potter",   "E43128", 15900, "D101"),
        Employee::new("David Motsinger",  "E27002", 19250, "D202"),
        Employee::new("Tim Sampair",      "E03033", 27000, "D101"),
        Employee::new("Kim Arlich",       "E10001", 57000, "D190"),
        Employee::new("Timothy Grove",    "E16398", 29900, "D190"),
        // Added to demonstrate various tie situations
        Employee::new("Kim Tie",          "E16400", 57000, "D190"),
        Employee::new("Timothy Tie",      "E16401", 29900, "D190"),
        Employee::new("Timothy Kim",      "E16401", 19900, "D190"),
    ]
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let n = {
        println!("How many top salaries to list? ");
        let mut buf = String::new();
        std::io::stdin().read_line(&mut buf)?;
        buf.trim().parse::<u32>()?
    };

    let mut employees = load_data();

    // Reverse order, then just pick top N employees
    employees.sort_by(|a, b| b.salary.cmp(&a.salary));

    let sorted = employees
        .into_iter()
        .fold(std::collections::BTreeMap::new(), |mut acc, next| {
            // We store the number of unique salaries as well to handle
            // ties (and list always all employees with the same salary)
            let mut bucket = acc
                .entry(next.department)
                .or_insert_with(|| (0, Vec::<Employee<_>>::new()));

            match bucket.1.last().map(|e| e.salary) {
                Some(last_salary) if last_salary == next.salary => {
                    if bucket.0 <= n {
                        bucket.1.push(next);
                    }
                }

                _ => {
                    if bucket.0 < n {
                        bucket.0 += 1; // Next unique salary
                        bucket.1.push(next);
                    }
                }
            }

            acc
        });

    for (department, (_, employees)) in sorted {
        println!("{}", department);

        employees
            .iter()
            .for_each(|employee| println!("    {:?}", employee));
    }

    Ok(())
}
