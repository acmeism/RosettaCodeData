{-# LANGUAGE TemplateHaskell #-}
import Control.Monad.Random (getRandomRs)
import Graphics.Gloss.Interface.Pure.Game
import Lens.Micro ((%~), (^.), (&), set)
import Lens.Micro.TH (makeLenses)

--------------------------------------------------------------------------------
-- all data types

data Snake = Snake { _body :: [Point], _direction :: Point }
makeLenses ''Snake

data World = World { _snake :: Snake , _food :: [Point]
                   , _score :: Int , _maxScore :: Int }
makeLenses ''World

--------------------------------------------------------------------------------
-- everything snake can do

moves (Snake b d) = Snake (step b d : init b) d
eats  (Snake b d) = Snake (step b d : b) d
bites (Snake b _) = any (== head b)
step ((x,y):_) (a,b) = (x+a, y+b)

turn (x',y') (Snake b (x,y)) | (x+x',y+y') == (0,0)  = Snake b (x,y)
                             | otherwise             = Snake b (x',y')

--------------------------------------------------------------------------------
-- all randomness

createWorld = do xs <- map fromIntegral <$> getRandomRs (2, 38 :: Int)
                 ys <- map fromIntegral <$> getRandomRs (2, 38 :: Int)
                 return (Ok, World snake (zip xs ys) 0 0)
                 where
                   snake = Snake [(20, 20)] (1,0)

-------------------------------------------------------------------------------
-- A tyny DSL for declarative description of business logic

data Status = Ok | Fail | Stop

continue = \x -> (Ok, x)
stop     = \x -> (Stop, x)
f >>> g  = \x -> case f x of { (Ok, y) -> g y; b -> b }    -- chain composition
f <|> g  = \x -> case f x of { (Fail, _) -> g x; b -> b }  -- alternative
p ==> f  = \x -> if p x then f x else (Fail, x)            -- condition
l .& f   = continue . (l %~ f)                             -- modification
l .= y   = continue . set l y                              -- setting

--------------------------------------------------------------------------------
-- all business logic

updateWorld _ =  id >>> (snakeEats <|> snakeMoves)
  where
    snakeEats  = (snakeFindsFood ==> (snake .& eats)) >>>
                 (score .& (+1)) >>> (food .& tail)

    snakeMoves = (snakeBitesTail ==> stop) <|>
                 (snakeHitsWall ==> stop) <|>
                 (snake .& moves)

    snakeFindsFood w = (w^.snake & moves) `bites` (w^.food & take 1)
    snakeBitesTail w = (w^.snake) `bites` (w^.snake.body & tail)
    snakeHitsWall w  = (w^.snake.body) & head & isOutside
    isOutside (x,y) = or [x <= 0, 40 <= x, y <= 0, 40 <= y]

--------------------------------------------------------------------------------
-- all event handing

handleEvents e (s,w) = f w
  where f = case s of
          Ok -> case e of
            EventKey (SpecialKey k) _ _ _ -> case k of
              KeyRight -> snake .& turn (1,0)
              KeyLeft  -> snake .& turn (-1,0)
              KeyUp    -> snake .& turn (0,1)
              KeyDown  -> snake .& turn (0,-1)
              _-> continue
            _-> continue
          _-> \w -> w & ((snake.body) .= [(20,20)]) >>>
                         (maxScore .& max (w^.score)) >>> (score .= 0)

--------------------------------------------------------------------------------
-- all graphics

renderWorld (s, w) = pictures [frame, color c drawSnake, drawFood, showScore]
  where c = case s of { Ok -> orange; _-> red }
        drawSnake = foldMap (rectangleSolid 10 10 `at`) (w^.snake.body)
        drawFood = color blue $ circleSolid 5 `at` (w^.food & head)
        frame = color black $ rectangleWire 400 400
        showScore = color orange $ scale 0.2 0.2 $ txt `at` (-80,130)
        txt = Text $ mconcat ["Score: ", w^.score & show
                             ,"   Maximal score: ", w^.maxScore & show]
        at p (x,y) = Translate (10*x-200) (10*y-200) p

--------------------------------------------------------------------------------

main = do world <- createWorld
          play inW white 7 world renderWorld handleEvents updateWorld
  where inW = InWindow "The Snake" (400, 400) (10, 10)
