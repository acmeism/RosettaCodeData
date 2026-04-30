haystack = %w(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo)

# First occurrence
haystack.index("Bush") # => 4

# Indexable#index returns nil if the needle is not found
haystack.index("Washington") # => nil

# Indexable#index! throws an exception if the needle is not found
haystack.index!("Washington") # => Unhandled exception: Element not found (Enumerable::NotFoundError)

# Indexable#rindex and Indexable#rindex! work the same way, only they search right to left
haystack.rindex("Bush")        # => 7
haystack.rindex("Washington")  # => nil
haystack.rindex!("Washington") # => Unhandled exception: Element not found (Enumerable::NotFoundError)
