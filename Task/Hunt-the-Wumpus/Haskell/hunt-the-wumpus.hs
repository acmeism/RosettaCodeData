import System.Random
import System.IO
import Data.List
import Data.Char
import Control.Monad

-- Rooms
cave :: [[Int]]
cave = [
    [1,4,7],    [0,2,9],   [1,3,11],   [2,4,13],   [0,3,5],
    [4,6,14],   [5,7,16],  [0,6,8],    [7,9,17],   [1,8,10],
    [9,11,18],  [2,10,12], [11,13,19], [3,12,14],  [5,13,15],
    [14,16,19], [6,15,17], [8,16,18],  [10,17,19], [12,15,18]]

caveSize :: Int
caveSize = length cave

-- Game state
data GameState = GameState {
    wumpus :: Int,
    player :: Int,
    arrows :: Int,
    pits :: [Int],
    bats :: [Int]
}

-- Print the state of the game
instance Show GameState where
    show g = "You are in room " ++ show (player g) ++ ". " ++
             "Adjacent rooms are: " ++ (intercalate ", " $ map show adjs) ++
             ".\nYou have " ++ show (arrows g) ++ " arrows.\n\n" ++
             adjMsgs
        where adjs    = cave!!player g
              adj     = any (`elem` adjs) . ($ g)
              adjMsgs = unlines $
                  ["You smell something terrible nearby." | adj $ pure.wumpus]
               ++ ["You hear a rustling." | adj bats]
               ++ ["You feel a cold wind blowing from a nearby cavern." | adj pits]

-- Generate random initial state
initGame :: StdGen -> GameState
initGame g =
    GameState {wumpus=w, player=p, arrows=5, pits=[p1,p2], bats=[b1,b2]}
    where [w, p, p1, p2, b1, b2] = take 6 $ nub $ map (`mod` 20) $ randoms g

-- Move wumpus into adjacent free room (if possible)
moveWumpus :: GameState -> StdGen -> GameState
moveWumpus s g
    | null freeAdj = s
    | otherwise = s {wumpus = freeAdj!!(fst $ randomR (0, length freeAdj-1) g)}
    where freeAdj = [r | r <- cave!!wumpus s, not $ elem r $ pits s++bats s]

-- Move player into random adjacent room
movePlayer :: GameState -> StdGen -> GameState
movePlayer s g = s {player = (cave !! player s) !! (fst $ randomR (0,2) g)}

-- Move or shoot
data Action = Move | Shoot | Quit deriving Show
inputAction :: IO Action
inputAction = do
    putStr "M)ove, S)hoot or Q)uit? "
    hFlush stdout
    ch <- getChar
    putStrLn ""
    case toLower ch of
        'm' -> return Move
        's' -> return Shoot
        'q' -> return Quit
        _   -> putStrLn "Invalid command" >> inputAction

-- Get room from current room
inputDestination :: Int -> IO Int
inputDestination cur = do
    putStr "Where to? "
    hFlush stdout
    input <- getLine
    case reads input of
        []      -> err "Sorry?"
        [(x,_)] -> if x `elem` (cave !! cur)
                   then return x
                   else err "Can't get there from here."
  where
    err x = putStrLn x >> inputDestination cur

-- Input yes or no
inputYesNo :: IO Bool
inputYesNo = do
    ch <- getChar
    case toLower ch of
        'n' -> putStrLn "" >> return False
        'y' -> putStrLn "" >> return True
        _   -> putStr (map chr [7,8]) >> inputYesNo

-- See if anything has happened to the player
data PlayerState = NoArrows | Bat | Pit | Wumpus | Alive deriving Show
playerState :: GameState -> PlayerState
playerState s | player s == wumpus s   = Wumpus
              | player s `elem` bats s = Bat
              | player s `elem` pits s = Pit
              | arrows s == 0          = NoArrows
              | otherwise              = Alive

-- Game loop
data GameResult = Win | Lose | Stop deriving Show
game :: GameState -> IO GameResult
game s = case playerState s of
    Wumpus   -> putStrLn "You find yourself face to face with the wumpus."
             >> putStrLn "It eats you alive in one bite.\n"
             >> return Lose
    Pit      -> putStrLn "You fall into a deep pit. Death waits at the bottom.\n"
             >> return Lose
    Bat      -> putStrLn "You have walked into the lair of a giant bat."
             >> putStrLn "It picks you up and deposits you outside.\n"
             >> newStdGen >>= game . movePlayer s
    NoArrows -> putStrLn "You notice you are out of arrows."
             >> putStrLn "You hear a large beast approaching.\n"
             >> return Lose
    Alive    -> do
        putStrLn ""
        putStrLn $ show s
        action <- inputAction
        case action of
            Quit -> return Stop
            _    -> do
                dest <- inputDestination (player s)
                case action of
                    Move  -> game s {player = dest}
                    Shoot -> shoot s dest

-- Shoot at the wumpus
shoot :: GameState -> Int -> IO GameResult
shoot s tgt
    | tgt == wumpus s = do
        putStrLn "Congratulations! You shot the wumpus!\n"
        return Win
    | otherwise = do
        let s'' = s { arrows = pred $ arrows s }
        putStrLn "That's a miss."
        awake <- randomRIO (0,3::Int)
        if awake /= 0 then do
            putStrLn "The wumpus wakes from his slumber."
            newStdGen >>= game . moveWumpus s''
        else
            game s''

-- Play a game
playGame :: IO ()
playGame = do
    result <- newStdGen >>= game . initGame
    case result of
        Stop -> return ()
        _    -> do
            case result of
                Lose -> putStrLn "You have met your demise."
                Win  -> putStrLn "You win!"
            putStr "\nAnother game? (Y/N) "
            inputYesNo >>= flip when playGame

main :: IO ()
main = do
    hSetBuffering stdin NoBuffering
    hSetBuffering stdout NoBuffering
    putStrLn "*** HUNT THE WUMPUS ***"
    putStrLn ""
    playGame
