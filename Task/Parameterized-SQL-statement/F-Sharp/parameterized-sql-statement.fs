open System.Data.SqlClient

[<EntryPoint>]
let main argv =
    use tConn = new SqlConnection("ConnectionString")

    use tCommand = new SqlCommand()
    tCommand.Connection <- tConn
    tCommand.CommandText <- "UPDATE players SET name = @name, score = @score, active = @active WHERE jerseyNum = @jerseyNum"

    tCommand.Parameters.Add(SqlParameter("@name", System.Data.SqlDbType.VarChar).Value = box "Smith, Steve") |> ignore
    tCommand.Parameters.Add(SqlParameter("@score", System.Data.SqlDbType.Int).Value = box 42) |> ignore
    tCommand.Parameters.Add(SqlParameter("@active", System.Data.SqlDbType.Bit).Value = box true) |> ignore
    tCommand.Parameters.Add(SqlParameter("@jerseyNum", System.Data.SqlDbType.Int).Value = box 99) |> ignore

    tCommand.ExecuteNonQuery() |> ignore
    0
