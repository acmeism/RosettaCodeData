// Version 1.2.41

import java.sql.DriverManager
import java.sql.Connection

fun main(args: Array<String>) {
    val url = "jdbc:mysql://localhost:3306/test"
    val username = "example"
    val password = "password123"
    val conn = DriverManager.getConnection(url, username, password)
    val query = conn.prepareStatement(
        "UPDATE players SET name = ?, score = ?, active = ? WHERE jerseyNum = ?"
    )
    with (query) {
        setString(1, "Smith, Steve")
        setInt(2, 42)
        setBoolean(3, true)
        setInt(4, 99)
        val rowCount = executeUpdate()
        if (rowCount == 0) println("Update failed")
        close()
    }
    conn.close()
}
