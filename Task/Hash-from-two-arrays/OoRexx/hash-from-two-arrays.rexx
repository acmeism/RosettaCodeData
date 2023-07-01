array1 = .array~of("Rick", "Mike", "David")
array2 = .array~of("555-9862", "555-5309", "555-6666")

-- if the index items are constrained to string objects, this can
-- be a directory too.
hash = .table~new

loop i = 1 to array1~size
    hash[array1[i]] = array2[i]
end
Say 'Enter a name'
Parse Pull name
Say name '->' hash[name]
