require "csv"

data =
"Employee Name,Employee ID,Salary,Department
Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190"

def show_top_salaries_per_group(groups, n)
  groups.each do |dept, emps|
    puts dept
    # sort by salary descending
    emps.sort_by {|emp| -emp[:salary].to_i}.first(n).each do |e|
      puts "    %-16s %6s %7d" % [e[:employee_name], e[:employee_id], e[:salary]]
    end
    puts
  end
end

table = CSV.parse(data, :headers=>true, :header_converters=>:symbol)
groups = table.group_by{|emp| emp[:department]}.sort

show_top_salaries_per_group(groups, 3)
