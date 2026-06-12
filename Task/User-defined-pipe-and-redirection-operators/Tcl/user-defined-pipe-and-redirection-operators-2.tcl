set file "List_of_computer_scientists.lst"
set aa [pipeline \
    << [pipeline < $file | head 4] [pipeline < $file | grep ALGOL | tee "ALGOL_pioneers.txt"] [pipeline < $file | tail 4] \
    | sort | uniq | tee "the_important_scientists.lst" | grep aa]
puts "Pioneer: $aa"
