# Project : Top rank per group
# Date    : 2017/12/10
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
salary = "Tyler Bennett,E10297,32000,D101
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

temp = substr(salary, ",", nl)
temp = str2list(temp)
depsal = newlist(13,4)
for n = 1 to len(temp)
     n1 = ceil(n/4)
     n2 = n%4
     if n2 = 0
        n2 = 4
     ok
     depsal[n1][n2] = temp[n]
next
for n = 1 to len(depsal)-1
     for m = n+1 to len(depsal)
          if strcmp(depsal[m][4], depsal[n][4]) < 0
              tmp = depsal[n]
              depsal[n] = depsal[m]
              depsal[m] = tmp
          ok
      next
next
for n = 1 to len(depsal)-1
     for m = n+1 to len(depsal)
           if (depsal[m][4] = depsal[n][4]) and (depsal[m][3] > depsal[n][3])
               tmp = depsal[n]
               depsal[n] = depsal[m]
               depsal[m] = tmp
           ok
      next
next
see "Department : " + depsal[1][4] + nl
see "Name                   " + "Id             " + "Salary" + nl + nl
see "" + depsal[1][1] + "      " + depsal[1][2] + "      " + depsal[1][3]+ nl
for n = 1 to len(depsal)-1
    if (depsal[n+1][4] != depsal[n][4])
        see nl
        see "Department : " + depsal[n+1][4] + nl
        see "Name                   " + "Id             " + "Salary" + nl + nl
        see "" + depsal[n+1][1] + "      " + depsal[n+1][2] + "      " + depsal[n+1][3]+ nl
     else
        see "" + depsal[n+1][1] + "      " + depsal[n+1][2] + "      " + depsal[n+1][3]+ nl
     ok
next
