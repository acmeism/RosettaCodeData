using MySql.Data.MySqlClient;

namespace rosettaMySQL
{
    class UserOperator
    {
        private MySqlConnection _connection;

        public UserOperator(MySqlConnection connection)
        {
            _connection = connection;
        }

        public bool CreateUser(string username, string password)
        {
            try
            {
                var salt = Hasher.GenSalt();
                var hash = Hasher.Hash(salt, password);
                var sql = $"INSERT INTO users " +
                          $"(username, pass_salt, pass_md5) " +
                          $"VALUES ('{username}','{salt}','{hash}')";
                using (var command = new MySqlCommand(sql, _connection))
                {
                    command.ExecuteNonQuery();
                    return true;
                }
            }
            catch (MySqlException e)
            {
                if (e.Number == 1062) //username is a duplicate
                {
                    return false;
                }
                else
                {
                    throw e;
                }
            }
        }

        public bool AuthenticateUser(string username, string password)
        {
            var sql = $"SELECT userid, username, pass_salt, pass_md5 " +
                      $"FROM users " +
                      $"WHERE username='{username}';";

            using (var command = new MySqlCommand(sql, _connection))
            using (var reader = command.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    reader.Read();
                    var salt = reader.GetString("pass_salt");
                    var hash = reader.GetString("pass_md5");
                    return (Hasher.Hash(salt, password) == hash);
                }
                else
                {
                    return false;
                }
            }
        }
    }
}
