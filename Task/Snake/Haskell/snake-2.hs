updateWorld _ =  id >>> snakeSeeksFood >>> (snakeEats <|> snakeMoves)
