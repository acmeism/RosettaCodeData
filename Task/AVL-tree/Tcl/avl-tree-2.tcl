# Create an AVL tree
AVL::Tree create tree

# Populate it with some semi-random data
for {set i 33} {$i < 127} {incr i} {
    [tree insert $i] setValue \
	[string repeat [format %c $i] [expr {1+int(rand()*5)}]]
}

# Print it out
tree print

# Look up a few values in the tree
for {set i 0} {$i < 10} {incr i} {
    set k [expr {33+int((127-33)*rand())}]
    puts $k=>[[tree lookup $k] value]
}

# Destroy the tree and all its nodes
tree destroy
