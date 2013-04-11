from collections import defaultdict
from heapq import nlargest

data = [('Employee Name', 'Employee ID', 'Salary', 'Department'),
        ('Tyler Bennett', 'E10297', 32000, 'D101'),
        ('John Rappl', 'E21437', 47000, 'D050'),
        ('George Woltman', 'E00127', 53500, 'D101'),
        ('Adam Smith', 'E63535', 18000, 'D202'),
        ('Claire Buckman', 'E39876', 27800, 'D202'),
        ('David McClellan', 'E04242', 41500, 'D101'),
        ('Rich Holcomb', 'E01234', 49500, 'D202'),
        ('Nathan Adams', 'E41298', 21900, 'D050'),
        ('Richard Potter', 'E43128', 15900, 'D101'),
        ('David Motsinger', 'E27002', 19250, 'D202'),
        ('Tim Sampair', 'E03033', 27000, 'D101'),
        ('Kim Arlich', 'E10001', 57000, 'D190'),
        ('Timothy Grove', 'E16398', 29900, 'D190')]

departments = defaultdict(list)
for rec in data[1:]:
    departments[rec[-1]].append(rec)

N = 3
format = " %-15s " * len(data[0])
for department, recs in sorted(departments.items()):
    print ("Department %s" % department)
    print (format % data[0])
    for rec in nlargest(N, recs, key=lambda rec: rec[-2]):
        print (format % rec)
    print('')
