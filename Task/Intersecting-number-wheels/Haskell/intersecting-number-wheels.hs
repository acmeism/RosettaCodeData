import Data.Char (isDigit)
import Data.List (mapAccumL)
import qualified Data.Map.Strict as M
import Data.Maybe (fromMaybe)

---------------- INTERSECTING NUMBER WHEELS --------------

clockWorkTick ::
  M.Map Char String ->
  (M.Map Char String, Char)
clockWorkTick = flip click 'A'
  where
    click wheels name
      | isDigit name = (wheels, name)
      | otherwise =
        ( click
            . flip
              (M.insert name . leftRotate)
              wheels
            <*> head
        )
          $ fromMaybe ['?'] $ M.lookup name wheels

leftRotate :: [a] -> [a]
leftRotate = take . length <*> (tail . cycle)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let wheelSets =
        [ [('A', "123")],
          [('A', "1B2"), ('B', "34")],
          [('A', "1DD"), ('D', "678")],
          [('A', "1BC"), ('B', "34"), ('C', "5B")]
        ]
  putStrLn "State of each wheel-set after 20 clicks:\n"
  mapM_ print $
    fmap
      ( flip
          (mapAccumL (const . clockWorkTick))
          (replicate 20 undefined)
          . M.fromList
      )
      wheelSets
  putStrLn "\nInitial state of the wheel-sets:\n"
  mapM_ print wheelSets
