-- The main sorting function
selectionSort :: Ord a => [a] -> [a]
selectionSort [] = []
selectionSort unsortedList =
    smallestElement : selectionSort remainingElements
    where
        -- Find the smallest element in the list
        smallestElement = findSmallest unsortedList

        -- Remove the first occurrence of that smallest element
        remainingElements = removeFirst smallestElement unsortedList


-- Function to find the smallest element in a list
-- Uses recursion to compare elements
findSmallest :: Ord a => [a] -> a
findSmallest [singleElement] = singleElement
findSmallest (firstElement:restOfList) =
    min firstElement (findSmallest restOfList)


-- Removes the first occurrence of a value from a list
-- This function is pure and returns a new list
removeFirst :: Eq a => a -> [a] -> [a]
removeFirst _ [] = []
removeFirst target (current:rest)
    | target == current = rest
    | otherwise = current : removeFirst target rest


-- Example usage
main :: IO ()
main = do
    let list_of_items = [ 'A', 'S', 'O', 'R', 'I', 'N', 'G', 'E', 'X', 'A', 'M', 'P', 'L', 'E']

    putStrLn "Original list:"
    print list_of_items

    let sorted_list_of_items = selectionSort list_of_items

    putStrLn "Sorted list:"
    print sorted_list_of_items
