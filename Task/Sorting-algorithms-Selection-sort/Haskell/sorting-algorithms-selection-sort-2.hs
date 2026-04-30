import Data.List (delete)

-- Sub-Function
selectionSort :: Ord a => [a] -> [a]
selectionSort [] = []
selectionSort xs =
    smallest : selectionSort (delete smallest xs)
    where smallest = minimum XS

-- Main test driver
main :: IO ()
main = do
    let list_of_items = [ 'A', 'S', 'O', 'R', 'I', 'N', 'G', 'E', 'X', 'A', 'M', 'P', 'L', 'E']

    putStrLn "Original list:"
    print list_of_items

    let sorted_list_of_items = selectionSort list_of_items

    putStrLn "Sorted list:"
    print sorted_list_of_items
