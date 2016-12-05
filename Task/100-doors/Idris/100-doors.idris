import Data.Vect

-- Creates list from 0 to n (not including n)
upTo : (m : Nat) -> Vect m (Fin m)
upTo Z = []
upTo (S n) = 0 :: (map FS (upTo n))

data DoorState = DoorOpen | DoorClosed

toggleDoor : DoorState -> DoorState
toggleDoor DoorOpen = DoorClosed
toggleDoor DoorClosed = DoorOpen

isOpen : DoorState -> Bool
isOpen DoorOpen = True
isOpen DoorClosed = False

initialDoors : Vect 100 DoorState
initialDoors = fromList $ map (\_ => DoorClosed) [1..100]

iterate : (n : Fin m) -> Vect m DoorState -> Vect m DoorState
iterate n doors {m} =
  map (\(idx, doorState) =>
          if ((S (finToNat idx)) `mod` (S (finToNat n))) == Z
              then toggleDoor doorState
              else doorState)
      (zip (upTo m) doors)

-- Returns all doors left open at the end
solveDoors : List (Fin 100)
solveDoors =
  findIndices isOpen $ foldl (\doors,val => iterate val doors) initialDoors (upTo 100)

main : IO ()
main = print $ map (\n => S (finToNat n)) solveDoors
