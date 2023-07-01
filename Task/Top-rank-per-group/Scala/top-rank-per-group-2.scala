import scala.slick.driver.H2Driver.simple._
import scala.slick.lifted.ProvenShape

// A Employees table with 4 columns: Employee ID, Employee Name, Department, Salary
class Emp(tag: Tag) extends Table[(String, String, String, Double)](tag, "EMP") {
  def id: Column[String] = column[String]("EMP_ID", O.PrimaryKey) // This is the primary key column
  def name: Column[String] = column[String]("EMP_NAME", O.NotNull)
  def deptId: Column[String] = column[String]("DEPT_ID", O.NotNull)
  def salary: Column[Double] = column[Double]("SALARY", O.NotNull)

  // Every table needs a * projection with the same type as the table's type parameter
  def * : ProvenShape[(String, String, String, Double)] = (id, name, deptId, salary)
}

// The main application
object TopNrankSLICK extends App {

  val topN = 3

  // The query interface for the Emp table
  val employees = TableQuery[Emp]

  // Create a connection (called a "session") to an in-memory H2 database
  Database.forURL("jdbc:h2:mem:hello", driver = "org.h2.Driver").withSession {
    implicit session =>

      // Create the schema
      employees.ddl.create

      // Fill the database
      val employeesInsertResult: Option[Int] = employees ++= Seq(
        ("E10297", "Tyler Bennett", "D101", 32000),
        ("E21437", "John Rappl", "D050", 47000),
        ("E00127", "George Woltman", "D101", 53500),
        ("E63535", "Adam Smith", "D202", 18000),
        ("E39876", "Claire Buckman", "D202", 27800),
        ("E04242", "David McClellan", "D101", 41500),
        ("E01234", "Rich Holcomb", "D202", 49500),
        ("E41298", "Nathan Adams", "D050", 21900),
        ("E43128", "Richard Potter", "D101", 15900),
        ("E27002", "David Motsinger", "D202", 19250),
        ("E03033", "Tim Sampair", "D101", 27000),
        ("E10001", "Kim Arlich", "D190", 57000),
        ("E16398", "Timothy Grove", "D190", 29900),
        ("E16399", "Timothy Grave", "D190", 29900),
        ("E16400", "Timothy Grive", "D190", 29900))

      /* Manual SQL / String Interpolation */
      // Required import for the sql interpolator
      import scala.slick.jdbc.StaticQuery.interpolation

      // Construct a SQL statement manually with an interpolated value
      val plainQuery = // First the bun - formatting SELECT clause
        sql"""select case LINE
         when 10 then
          'Tot.' || LPAD(POPULATION, 2) || ' Employees in ' || TIE_COUNT ||
          ' deps.Avg salary:' || TO_CHAR(SALARY, '99990.99')
         when 30 then
          '-'
         when 50 then
          'Department: ' || DEPT_ID || ', pop: ' || POPULATION ||
          '. Avg Salary: ' || TO_CHAR(SALARY, '99990.99')
         when 70 then
          LPAD('Employee ID', 14) || LPAD('Employee name', 20) ||
          LPAD('Salary', 9) || 'Rank'
         when 90 then
          LPAD('+', 14, '-') || LPAD('+', 20, '-') || LPAD('+', 9, '-') ||
          LPAD('+', 4, '-')
         else
          LPAD(' ', 8) || LPAD(EMP_ID, 6) || LPAD(EMP_NAME, 20) ||
          TO_CHAR(SALARY, '99990.99') || LPAD(case when TIE_COUNT = 1 then ' ' else 'T' end || RANK, 4)
       end "Top rank per group"
  from (select 10 LINE
              ,null EMP_ID
              ,null EMP_NAME
              ,' ' DEPT_ID
              ,avg(SALARY) SALARY
              ,0 RANK
              ,count(distinct DEPT_ID) TIE_COUNT
              ,count(*) POPULATION
          from EMP
        union all
        select 30      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 50 LINE
              ,null EMP_ID
              ,null EMP_NAME
              ,DEPT_ID
              ,avg(SALARY) SALARY
              ,0 RANK
              ,0 TIE_COUNT
              ,count(*) POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 70      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 90      LINE
              ,null    EMP_ID
              ,null    EMP_NAME
              ,DEPT_ID
              ,0       SALARY
              ,0       RANK
              ,0       TIE_COUNT
              ,0       POPULATION
          from EMP
         group by DEPT_ID
        union all
        select 110 LINE
              ,EMP_ID
              ,EMP_NAME
              ,DEPT_ID
              ,SALARY
              ,(select count(distinct EMP4.SALARY)
                  from EMP EMP4
                 where EMP4.DEPT_ID = EMP3.DEPT_ID
                   and EMP4.SALARY >= EMP3.SALARY) RANK
              ,(select count(*)
                  from EMP EMP2
                 where EMP2.DEPT_ID = EMP3.DEPT_ID
                   and EMP2.SALARY = EMP3.SALARY) TIE_COUNT
              ,0 POPULATION
          from EMP EMP3
         where $topN >= -- Here is the meat, Correlated subquery
               (select count(distinct EMP4.SALARY)
                  from EMP EMP4
                 where EMP4.DEPT_ID = EMP3.DEPT_ID
                   and EMP4.SALARY >= EMP3.SALARY))
 order by DEPT_ID ,LINE ,SALARY desc, EMP_ID""".as[String]

      // Execute the query
      plainQuery.foreach(println(_))
  } // session
} // TopNrankSLICK
