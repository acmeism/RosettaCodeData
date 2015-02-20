% emp(name,id,salary,dpt)
emp('Tyler Bennett','E10297',32000,'D101').
emp('John Rappl','E21437',47000,'D050').
emp('George Woltman','E00127',53500,'D101').
emp('Adam Smith','E63535',18000,'D202').
emp('Claire Buckman','E39876',27800,'D202').
emp('David McClellan','E04242',41500,'D101').
emp('Rich Holcomb','E01234',49500,'D202').
emp('Nathan Adams','E41298',21900,'D050').
emp('Richard Potter','E43128',15900,'D101').
emp('David Motsinger','E27002',19250,'D202').
emp('Tim Sampair','E03033',27000,'D101').
emp('Kim Arlich','E10001',57000,'D190').
emp('Timothy Grove','E16398',29900,'D190').

departments(Depts) :-  % Find the set of departments
  findall(Dpt, emp(_,_,_,Dpt), DList), list_to_set(DList, Depts).

greater(emp(_,_,Sal1,_), emp(_,_,Sal2,_)) :-
  Sal1 > Sal2.  % First employee salary greater than second

% Maintains a decreasing ordered list of employees truncated after (N) items.
%  Rule 1: For N=0, always return an empty set.
%  Rule 2: Add employee with greater salary at start of list, call with N-1
%  Rule 3: Try to add new employee at N-1
%  Rule 4: for an empty input list regardless of N, add the new employee
topSalary(0, _, _, []).
topSalary(N, Emp, [E|R], [Emp|Res]) :-
  greater(Emp,E), N0 is N - 1, !, topSalary(N0, E, R, Res).
topSalary(N, Emp, [E|R], [E|Res]) :-
  N0 is N - 1, !, topSalary(N0, Emp, R, Res).
topSalary(_, Emp, [], [Emp]).

% For each employee, add him to the list if top salary
topEmps(N, [Emp|Emps], R, Res) :-
  topSalary(N, Emp, R, Rt), !, topEmps(N, Emps, Rt, Res).
topEmps(_, [], Res, Res).

% For each department, find the list of top employees in that department
topDeps(N, [Dept|T], [dept(Dept,Ro)|Res]) :-
  findall(emp(Name, Id, Sal, Dept), emp(Name, Id, Sal, Dept), Emps),
  topEmps(N, Emps, [], Ro), !, topDeps(N, T, Res).
topDeps(_, [], []).

% Calculate and report the list of highest salaried employees per department
topDeps(N) :-
  departments(D), topDeps(N, D, Res),
  member(dept(Dept,R), Res),
  writef('Department: %w\n', [Dept]),
  member(emp(Name,Id,Sal,_), R),
  writef('  ID: %w\t%w\tSalary: %w\n', [Id,Name,Sal]),
  fail.
topDeps(_).
