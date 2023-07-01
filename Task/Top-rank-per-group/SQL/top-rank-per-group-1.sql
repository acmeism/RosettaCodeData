create table EMP
(
EMP_ID  varchar2(6 char),
EMP_NAMEvarchar2(20 char),
DEPT_ID varchar2(4 char),
SALARY  number(10,2)
);

insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E21437','John Rappl','D050',47000);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E10297','Tyler Bennett','D101',32000);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E00127','George Woltman','D101',53500);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E63535','Adam Smith','D202',18000);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E39876','Claire Buckman','D202',27800);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E04242','David McClellan','D101',41500);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E41298','Nathan Adams','D050',21900);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E43128','Richard Potter','D101',15900);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E27002','David Motsinger','D202',19250);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E03033','Tim Sampair','D101',27000);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E10001','Kim Arlich','D190',57000);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E16398','Timothy Grove','D190',29900);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E01234','Rich Holcomb','D202',49500);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E16399','Timothy Grave','D190',29900);
insert into EMP (EMP_ID, EMP_NAME, DEPT_ID, SALARY)
 values ('E16400','Timothy Grive','D190',29900);
COMMIT;
