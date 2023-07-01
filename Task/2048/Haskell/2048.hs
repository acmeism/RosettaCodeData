import System.IO
import Data.List
import Data.Maybe
import Control.Monad
import Data.Random
import Data.Random.Distribution.Categorical
import System.Console.ANSI
import Control.Lens

-- Logic

-- probability to get a 4
prob4 :: Double
prob4 = 0.1

type Position = [[Int]]

combine, shift :: [Int]->[Int]
combine (x:y:l) | x==y = (2*x) : combine l
combine (x:l) = x : combine l
combine [] = []

shift l = take (length l) $ combine (filter (>0) l) ++ [0,0..]

reflect :: [[a]] ->[[a]]
reflect = map reverse

type Move = Position -> Position

left, right, up, down :: Move
left = map shift
right = reflect . left . reflect
up = transpose . left . transpose
down = transpose . right . transpose

progress :: Eq a => (a -> a) -> a -> Maybe a
progress f pos = if pos==next_pos then Nothing else Just next_pos where next_pos= f pos

lost, win:: Position -> Bool
lost pos = all isNothing [progress move pos| move<-[left,right,up,down] ]

win = any $ any (>=2048)

go :: Position -> Maybe Move -> Maybe Position
go pos move = move >>= flip progress pos


{-
-- Adding 2 or 4 without lens:
update l i a = l1 ++ a : l2 where (l1,_:l2)=splitAt i l
indicesOf l = [0..length l-1]

add a x y pos = update pos y $ update (pos !! y) x a

add2or4 ::  Position -> RVar Position
add2or4 pos = do
  (x,y) <-  randomElement [(x,y) | y<-indicesOf pos, x<-indicesOf (pos!!y), pos!!y!!x ==0  ]
  a <- categorical [(0.9::Double,2), (0.1,4) ]
  return $ add a x y pos
-}

-- or with lens:
indicesOf :: [a] -> [ReifiedTraversal' [a] a]
indicesOf l = [ Traversal $ ix i | i <- [0..length l - 1] ]

indices2Of :: [[a]] -> [ReifiedTraversal' [[a]] a]
indices2Of ls = [ Traversal $ i.j | Traversal i <- indicesOf ls, let Just l = ls ^? i, Traversal j <- indicesOf l]

add2or4 ::  Position -> RVar Position
add2or4 pos = do
  xy <-  randomElement [ xy | Traversal xy <- indices2Of pos, pos ^? xy == Just 0 ]
  a <- categorical [(1-prob4, 2), (prob4, 4) ]
  return $  pos & xy .~ a
-- Easy, is'n it'?

-- Main loop
play :: Position -> IO ()
play pos = do
   c <- getChar
   case go pos $ lookup c [('D',left),('C',right),('A',up),('B',down)] of
      Nothing -> play pos
      Just pos1 -> do
         pos2 <- sample $ add2or4 pos1
         draw pos2
         when (win pos2 && not (win pos)) $ putStrLn $ "You win! You may keep going."
         if lost pos2 then putStrLn "You lost!"
            else play pos2

main :: IO ()
main = do
  pos <- sample $ add2or4 $ replicate 4 (replicate 4 0)
  draw pos
  play pos

-- Rendering
-- See https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
colors =
 [(0,"\ESC[38;5;234;48;5;250m     ")
 ,(2,"\ESC[38;5;234;48;5;255m  2  ")
 ,(4,"\ESC[38;5;234;48;5;230m  4  ")
 ,(8,"\ESC[38;5;15;48;5;208m  8  ")
 ,(16,"\ESC[38;5;15;48;5;209m  16 ")
 ,(32,"\ESC[38;5;15;48;5;203m  32 ")
 ,(64,"\ESC[38;5;15;48;5;9m  64 ")
 ,(128,"\ESC[38;5;15;48;5;228m 128 ")
 ,(256,"\ESC[38;5;15;48;5;227m 256 ")
 ,(512,"\ESC[38;5;15;48;5;226m 512 ")
 ,(1024,"\ESC[38;5;15;48;5;221m 1024")
 ,(2048,"\ESC[38;5;15;48;5;220m 2048")
 ,(4096,"\ESC[38;5;15;48;5;0m 4096")
 ,(8192,"\ESC[38;5;15;48;5;0m 8192")
 ,(16384,"\ESC[38;5;15;48;5;0m16384")
 ,(32768,"\ESC[38;5;15;48;5;0m32768")
 ,(65536,"\ESC[38;5;15;48;5;0m65536")
 ,(131072,"\ESC[38;5;15;48;5;90m131072")
 ]

showTile x = fromJust (lookup x colors) ++ "\ESC[B\^H\^H\^H\^H\^H     \ESC[A\ESC[C"

draw :: Position -> IO ()
draw pos = do
  setSGR [Reset]
  clearScreen
  hideCursor
  hSetEcho stdin False
  hSetBuffering stdin NoBuffering
  setSGR [SetConsoleIntensity BoldIntensity]
  putStr "\ESC[38;5;234;48;5;248m" -- set board color
  setCursorPosition 0 0
  replicateM_ 13 $ putStrLn $ replicate 26 ' '
  setCursorPosition 1 1
  putStrLn $ intercalate "\n\n\n\ESC[C" $ concatMap showTile `map` pos
