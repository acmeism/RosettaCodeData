    snakeSeeksFood w = w & snake .& turns optimalDirection
      where
        optimalDirection = minimumBy (comparing distanceToFood) safeTurns

        safeTurns = filter safe [(x,y),(-y,x),(y,-x)] `ifEmpty` [(x,y)]
          where (x,y) = w^.snake.direction
                safe d = let w'' = w & snake %~ moves . turns d
                         in not (snakeBitesTail w'' || snakeHitsWall w'')
                lst `ifEmpty` x = if null lst then x else lst

        distanceToFood d = let (a,b) = w^.snake & turns d & moves & (^.body) & head
                               (x,y) = w^.food & head
                           in (a-x)^2 + (b-y)^2
