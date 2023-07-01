using System;
using MySql.Data.MySqlClient;

namespace rosettaMySQL
{
    class Program
    {
        public static MySqlConnection ConnectDB(string server, int port, string db,
                                                string username, string password)
        {
            var connectStr = $"server={server};" +
                             $"user={username};" +
                             $"database={db};" +
                             $"port={port};" +
                             $"password={password}";
            return new MySqlConnection(connectStr);
        }

        static void Main(string[] args)
        {
            try
            {
                var connection = ConnectDB("localhost", 3306, "test", "root", "password");
                connection.Open();
                var userOperator = new UserOperator(connection);
                Console.WriteLine("Bob has been created: " + userOperator.CreateUser("Bob", "123456"));
                Console.WriteLine("Bob has been duplicated: " + userOperator.CreateUser("Bob", "123456"));
                Console.WriteLine("Wrong password works: " + userOperator.AuthenticateUser("BOB", "notpassword"));
                Console.WriteLine("Right password works: " + userOperator.AuthenticateUser("BOB", "123456"));
            }
            catch(MySqlException e)
            {
                switch(e.Number)
                {
                    case 0:
                        Console.WriteLine("Cannot connect to server");
                        break;
                    case 1045:
                        Console.WriteLine("Invalid database username/password");
                        break;
                    default:
                        Console.WriteLine(e.ToString());
                        Console.WriteLine(e.Number);
                        break;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }
        }
    }
}
