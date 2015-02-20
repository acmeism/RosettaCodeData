myArray as (int) = (1, 2, 3) // Size based on initialization
fixedArray as (int) = array(int, 1) // Given size(1 in this case)

myArray[0] = 10

myArray = myArray + fixedArray // Append arrays

print myArray[0]
