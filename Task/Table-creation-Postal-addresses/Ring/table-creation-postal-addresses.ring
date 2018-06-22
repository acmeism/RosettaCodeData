# Project : Table creation/Postal addresses
# Date    : 2018/04/19
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
oSQLite = sqlite_init()

sqlite_open(oSQLite,"mytest.db")

sql = "CREATE TABLE ADDRESS ("  +
         "addrID INT NOT NULL," +
         "street CHAR(50) NOT NULL," +
         "city CHAR(25) NOT NULL," +
         "state CHAR(2), NOT NULL" +
         "zip CHAR(20) NOT NULL);"

sqlite_execute(oSQLite,sql)
