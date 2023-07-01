# a relatively readable version - creates a distinct array

def sequential_sort(array)
  sorted = []

  while array.any?
    index_of_smallest_element = find_smallest_index(array) # defined below
    sorted << array.delete_at(index_of_smallest_element)
  end

  sorted
end

def find_smallest_index(array)
  smallest_element = array[0]
  smallest_index = 0

  array.each_with_index do |ele, idx|
    if ele < smallest_element
      smallest_element = ele
      smallest_index = idx
    end
  end

  smallest_index
end

puts "sequential_sort([9, 6, 8, 7, 5]): #{sequential_sort([9, 6, 8, 7, 5])}"
# prints: sequential_sort([9, 6, 8, 7, 5]): [5, 6, 7, 8, 9]



# more efficient version - swaps the array's elements in place

def sequential_sort_with_swapping(array)
  array.each_with_index do |element, index|
    smallest_unsorted_element_so_far = element
    smallest_unsorted_index_so_far = index

    (index+1...array.length).each do |index_value|
      if array[index_value] < smallest_unsorted_element_so_far
        smallest_unsorted_element_so_far = array[index_value]
        smallest_unsorted_index_so_far = index_value
      end
    end

    # swap index_value-th smallest element for index_value-th element
    array[index], array[smallest_unsorted_index_so_far] = array[smallest_unsorted_index_so_far], array[index]
  end

  array
end

puts "sequential_sort_with_swapping([7,6,5,9,8,4,3,1,2,0]): #{sequential_sort_with_swapping([7,6,5,9,8,4,3,1,2,0])}"
# prints: sequential_sort_with_swapping([7,6,5,9,8,4,3,1,2,0]): [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
