use AppleScript version "2.3.1" -- Mac OS X 10.9 (Mavericks) or later.
use sorter : script ¬
    "Custom Iterative Ternary Merge Sort" -- <www.macscripter.net/t/timsort-and-nigsort/71383/3>

on topNSalariesPerDepartment(employeeRecords, n)
    set output to {}
    set employeeCount to (count employeeRecords)
    if ((employeeCount > 0) and (n > 0)) then
        -- Sort a copy of the employee record list by department
        -- with descending subsorts on salary.
        copy employeeRecords to employeeRecords
        script comparer
            on isGreater(a, b)
                return ((a's department > b's department) or ¬
                    ((a's department = b's department) and (a's salary < b's salary)))
            end isGreater
        end script
        considering numeric strings
            tell sorter to sort(employeeRecords, 1, employeeCount, {comparer:comparer})
        end considering

        -- Initialise the output with data from the first record in the sorted list,
        -- then work through the rest of the list.
        set {department:previousDepartment, salary:previousSalary} to beginning of employeeRecords
        set {mv, topSalaries} to {"-", {previousSalary}}
        set end of output to {department:previousDepartment, salaries:topSalaries}
        repeat with i from 2 to employeeCount
            set {department:thisDepartment, salary:thisSalary} to item i of employeeRecords
            if (thisDepartment = previousDepartment) then
                if ((thisSalary < previousSalary) and ((count topSalaries) < n)) then
                    set end of topSalaries to thisSalary
                    set previousSalary to thisSalary
                end if
            else
                -- First record of the next department.
                -- Pad out the previous department's salary list if it has fewer than n entries.
                repeat (n - (count topSalaries)) times
                    set end of topSalaries to mv
                end repeat
                -- Start a result record for the new department and add it to the output.
                set topSalaries to {thisSalary}
                set end of output to {department:thisDepartment, salaries:topSalaries}
                set previousDepartment to thisDepartment
                set previousSalary to thisSalary
            end if
        end repeat
        -- Pad the last department's salary list if necessary.
        repeat (n - (count topSalaries)) times
            set end of topSalaries to mv
        end repeat
    end if

    return output
end topNSalariesPerDepartment

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on task()
    set employeeRecords to {¬
        {|name|:"Tyler Bennett", |ID|:"E10297", salary:32000, department:"D101"}, ¬
        {|name|:"John Rappl", |ID|:"E21437", salary:47000, department:"D050"}, ¬
        {|name|:"George Woltman", |ID|:"E00127", salary:53500, department:"D101"}, ¬
        {|name|:"Adam Smith", |ID|:"E63535", salary:18000, department:"D202"}, ¬
        {|name|:"Claire Buckman", |ID|:"E39876", salary:27800, department:"D202"}, ¬
        {|name|:"David McClellan", |ID|:"E04242", salary:41500, department:"D101"}, ¬
        {|name|:"Rich Holcomb", |ID|:"E01234", salary:49500, department:"D202"}, ¬
        {|name|:"Nathan Adams", |ID|:"E41298", salary:21900, department:"D050"}, ¬
        {|name|:"Richard Potter", |ID|:"E43128", salary:15900, department:"D101"}, ¬
        {|name|:"David Motsinger", |ID|:"E27002", salary:19250, department:"D202"}, ¬
        {|name|:"Tim Sampair", |ID|:"E03033", salary:27000, department:"D101"}, ¬
        {|name|:"Kim Arlich", |ID|:"E10001", salary:57000, department:"D190"}, ¬
        {|name|:"Timothy Grove", |ID|:"E16398", salary:29900, department:"D190"}, ¬
        {|name|:"Simila Pey", |ID|:"E16399", salary:29900, department:"D190"} ¬
            }
    set n to 4
    set topSalaryRecords to topNSalariesPerDepartment(employeeRecords, n)

    -- Derive a text report from the result.
    set report to {"Top " & n & " salaries per department:"}
    repeat with thisRecord in topSalaryRecords
        set end of report to thisRecord's department & ":    " & join(thisRecord's salaries, "  ")
    end repeat
    return join(report, linefeed)
end task

task()
