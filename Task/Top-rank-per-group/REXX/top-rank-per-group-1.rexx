/*REXX program displays the top N salaries in each department (internal table)*/
parse arg topN .                       /*get optional # for the top N salaries*/
if topN==''  then topN=1               /*Not specified?  Then use the default.*/
say 'Finding the top '   topN   ' salaries in each department.';             say
@.=      /*════════ employee name      ID    salary   dept. ═══════ */
            @.1 = "Tyler Bennett    ,E10297,  32000,  D101"
            @.2 = "John Rappl       ,E21437,  47000,  D050"
            @.3 = "George Woltman   ,E00127,  53500,  D101"
            @.4 = "Adam Smith       ,E63535,  18000,  D202"
            @.5 = "Claire Buckman   ,E39876,  27800,  D202"
            @.6 = "David McClellan  ,E04242,  41500,  D101"
            @.7 = "Rich Holcomb     ,E01234,  49500,  D202"
            @.8 = "Nathan Adams     ,E41298,  21900,  D050"
            @.9 = "Richard Potter   ,E43128,  15900,  D101"
           @.10 = "David Motsinger  ,E27002,  19250,  D202"
           @.11 = "Tim Sampair      ,E03033,  27000,  D101"
           @.12 = "Kim Arlich       ,E10001,  57000,  D190"
           @.13 = "Timothy Grove    ,E16398,  29900,  D190"
depts=
              do j=1  until @.j==''    /*build database elements from @ array.*/
              parse var  @.j  name.j   ','   id.j   ","   sal.j   ','   dept.j .
              if wordpos(dept.j,depts)==0  then depts=depts dept.j
              end   /*j*/
employees=j-1
#d=words(depts)
say 'There are '    employees    'employees, '   #d    "departments: "     depts
say
    do dep=1  for #d;        say       /*process each of the departments.     */
    Xdept=word(depts,dep)              /*current department being processed.  */
        do topN;             highSal=0 /*process the top  N  salaries.        */
        h=0                            /*point to the highest paid employee.  */
            do e=1  for employees      /*process each employee in department. */
            if dept.e\==Xdept | sal.e<highSal  then iterate      /*wrong info.*/
            highSal=sal.e;   h=e       /*a higher salary was just found.      */
            end   /*e*/

        if h==0  then iterate          /*do we have no highest paid this time?*/
        say 'department:  '    dept.h     " $"||sal.h+0    id.h    space(name.h)
        dept.h=                        /*make sure we see the employee again. */
        end       /*topN*/
    end           /*dep*/
                                       /*stick a fork in it,  we're all done. */
