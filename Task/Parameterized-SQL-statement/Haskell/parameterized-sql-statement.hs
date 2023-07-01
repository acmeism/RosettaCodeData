module Main (main) where

import           Database.HDBC (IConnection, commit, run, toSql)

updatePlayers :: IConnection a => a -> String -> Int -> Bool -> Int -> IO Bool
updatePlayers conn name score active jerseyNum = do
    rowCount <- run conn
        "UPDATE players\
        \ SET name = ?, score = ?, active = ?\
        \ WHERE jerseyNum = ?"
        [ toSql name
        , toSql score
        , toSql active
        , toSql jerseyNum
        ]
    commit conn
    return $ rowCount == 1

main :: IO ()
main = undefined
