// Version 1.2.41

import java.sql.Connection
import java.sql.DriverManager
import java.sql.ResultSet
import java.security.MessageDigest
import java.security.SecureRandom
import java.math.BigInteger

class UserManager {
    private lateinit var dbConnection: Connection

    private fun md5(message: String): String {
        val hexString = StringBuilder()
        val bytes = message.toByteArray()
        val md = MessageDigest.getInstance("MD5")
        val dig = md.digest(bytes)
        for (i in 0 until dig.size) {
            val hex = (0xff and dig[i].toInt()).toString(16)
            if (hex.length == 1) hexString.append('0')
            hexString.append(hex)
        }
        return hexString.toString()
    }

    fun connectDB(host: String, port: Int, db: String, user: String, pwd: String) {
        Class.forName("com.mysql.jdbc.Driver")
        dbConnection = DriverManager.getConnection(
            "jdbc:mysql://$host:$port/$db", user, pwd
        )
    }

    fun createUser(user: String, pwd: String): Boolean {
        val random = SecureRandom()
        val salt = BigInteger(130, random).toString(16)
        val insert = "INSERT INTO users " +
            "(username, pass_salt, pass_md5) " +
            "VALUES (?, ?, ?)"
        try {
            val pstmt = dbConnection.prepareStatement(insert)
            with (pstmt) {
                setString(1, user)
                setString(2, salt)
                setString(3, md5(salt + pwd))
                val rowCount = executeUpdate()
                close()
                if (rowCount == 0) return false
            }
            return true
        }
        catch (ex: Exception) {
            return false
        }
    }

    fun authenticateUser(user: String, pwd: String): Boolean {
        val select = "SELECT pass_salt, pass_md5 FROM users WHERE username = ?"
        lateinit var res: ResultSet
        try {
            val pstmt = dbConnection.prepareStatement(select)
            with (pstmt) {
                setString(1, user)
                res = executeQuery()
                res.next()  // assuming that username is unique
                val passSalt = res.getString(1)
                val passMD5  = res.getString(2)
                close()
                return passMD5 == md5(passSalt + pwd)
            }
        }
        catch (ex: Exception) {
            return false
        }
        finally {
            if (!res.isClosed) res.close()
        }
    }

    fun closeConnection() {
        if (!dbConnection.isClosed) dbConnection.close()
    }
}

fun main(args: Array<String>) {
    val um = UserManager()
    with (um) {
        try {
            connectDB("localhost", 3306, "test", "root", "admin")
            if (createUser("johndoe", "test")) println("User created")
            if (authenticateUser("johndoe", "test")) {
                println("User authenticated")
            }
        }
        catch(ex: Exception) {
            ex.printStackTrace()
        }
        finally {
            closeConnection()
        }
    }
}
