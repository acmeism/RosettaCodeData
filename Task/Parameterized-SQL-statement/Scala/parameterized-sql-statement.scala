import slick.jdbc.H2Profile.api._
import slick.sql.SqlProfile.ColumnOption.SqlType

import scala.concurrent.Await
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration

object PlayersApp extends App {
  lazy val playerRecords = TableQuery[PlayerRecords]
  val db = Database.forURL("jdbc:h2:mem:test1;DB_CLOSE_DELAY=-1", driver = "org.h2.Driver")
  //  Pre-compiled parameterized statement
  val compiledUpdate = Compiled { jerseyN: Rep[Int] =>
    for {c <- playerRecords if c.jerseyNum === jerseyN} yield (c.name, c.score, c.active)
  }

  def setup = DBIO.seq(
    playerRecords.schema.create,
    playerRecords ++= Seq( // JDBC batch update
                          (7, "Roethlisberger, Ben", 94.1f, true),
                          (11, "Smith, Alex", 85.3f, true),
                          (18, "Manning, Payton", 96.5f, false),
                          (99, "Doe, John", 15f, false))
  )

  def queryPlayers(prelude: String) = {
    println("\n  " +prelude)
    println(
      "│ Name                          │Scor│ Active │Jerseynum│\n" +
      "├───────────────────────────────┼────┼────────┼─────────┤"
    )
    DBIO.seq(playerRecords.result.map(_.map {
      case (jerseyN, name, score, active) =>
        f"$name%32s $score ${(if (active) "" else "in") + "active"}%8s $jerseyN%8d"
    }.foreach(println)))
  }

  // Definition of the PLAYERS table
  class PlayerRecords(tag: Tag) extends Table[(Int, String, Float, Boolean)](tag, "PLAYER_RECORDS") {
    def active = column[Boolean]("ACTIVE")
    def jerseyNum = column[Int]("JERSEY_NUM", O.PrimaryKey)
    def name = column[String]("NAME", SqlType("VARCHAR2(32)"))
    def score = column[Float]("SCORE")

    def * = (jerseyNum, name, score, active)
  }

  println(s"The pre-compiled parameterized update DML:\n${compiledUpdate(0).updateStatement}")

  Await.result(db.run(
    for { // Using the for comprehension
    _ <- setup
    _ <- queryPlayers("Before update:")
    n <- compiledUpdate(99).update("Smith, Steve", 42f, true)
    _ <- queryPlayers("After update:")
  } yield n), Duration.Inf)

}
