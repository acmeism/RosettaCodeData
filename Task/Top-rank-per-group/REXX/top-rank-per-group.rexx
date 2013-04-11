/*REXX program shows top N salaries in each department (internal table).*/
parse arg topN .                       /*get number for top N salaries. */
if topN==''  then topN=1               /*if none, then assume only  1.  */
say 'Finding top' topN 'salaries in each department.';    say
@.=
    /*employee name,  ID, salary, dept.*/
 @.1="Tyler Bennett,E10297,32000,D101"
 @.2="John Rappl,E21437,47000,D050"
 @.3="George Woltman,E00127,53500,D101"
 @.4="Adam Smith,E63535,18000,D202"
 @.5="Claire Buckman,E39876,27800,D202"
 @.6="David McClellan,E04242,41500,D101"
 @.7="Rich Holcomb,E01234,49500,D202"
 @.8="Nathan Adams,E41298,21900,D050"
 @.9="Richard Potter,E43128,15900,D101"
@.10="David Motsinger,E27002,19250,D202"
@.11="Tim Sampair,E03033,27000,D101"
@.12="Kim Arlich,E10001,57000,D190"
@.13="Timothy Grove,E16398,29900,D190"
depts=
                do j=1  until @.j==''  /*build database elements.       */
                parse var @.j name.j ',' id.j "," sal.j ',' dept.j
                if wordpos(dept.j,depts)==0  then depts=depts dept.j
                end   /*j*/
employees=j-1
#d=words(depts)
say employees 'employees,' #d "departments:" depts;   say

  do dep=1  for #d                     /*process each department.       */
  Xdept=word(depts,dep)                /*current dept. being processed. */

         do topN                       /*process the top  N  salaries.  */
         highsal=0                     /*highest salary  (so far).      */
         h=0                           /*point to the highest paid emp. */
                do e=1  for employees  /*process each employee in Dept. */
                if dept.e\==Xdept | sal.e<highsal  then iterate
                highsal=sal.e          /*We found a higher salary.      */
                h=e                    /*Remember the high employee (H).*/
                end   /*e*/

         if h==0  then iterate         /*no highest paid this time?     */
         say 'department: ' dept.h " $"sal.h id.h name.h  /*show & tell.*/
         dept.h=''                     /*make sure we see employee again*/
         end     /*do topN*/
  say                                  /*write blank line between depts.*/
  end            /*dep*/
                                       /*stick a fork in it, we're done.*/
