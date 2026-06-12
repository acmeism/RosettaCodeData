#!/usr/bin/tclsh

# Red-Black Tree implementation in Tcl

# Node class implementation using namespace
namespace eval Node {
    # Constructor
    proc new {val} {
        set obj [namespace current]::[incr ::nodeCounter]
        namespace eval $obj {
            variable val
            variable parent
            variable left
            variable right
            variable color
        }
        set ${obj}::val $val
        set ${obj}::parent ""
        set ${obj}::left ""
        set ${obj}::right ""
        set ${obj}::color 1  ;# Red Node as new node is always inserted as Red Node (1=RED, 0=BLACK)
        return $obj
    }

    # Get/Set methods
    proc getVal {obj} { return [set ${obj}::val] }
    proc getParent {obj} { return [set ${obj}::parent] }
    proc getLeft {obj} { return [set ${obj}::left] }
    proc getRight {obj} { return [set ${obj}::right] }
    proc getColor {obj} { return [set ${obj}::color] }

    proc setVal {obj val} { set ${obj}::val $val }
    proc setParent {obj parent} { set ${obj}::parent $parent }
    proc setLeft {obj left} { set ${obj}::left $left }
    proc setRight {obj right} { set ${obj}::right $right }
    proc setColor {obj color} { set ${obj}::color $color }
}

# RBTree class implementation
namespace eval RBTree {
    variable nodeCounter 0

    # Constructor
    proc new {} {
        set obj [namespace current]::[incr ::treeCounter]
        namespace eval $obj {
            variable NULL
            variable root
        }

        # Create NULL node
        set ${obj}::NULL [Node::new 0]
        Node::setColor [set ${obj}::NULL] 0  ;# BLACK
        Node::setLeft [set ${obj}::NULL] ""
        Node::setRight [set ${obj}::NULL] ""
        set ${obj}::root [set ${obj}::NULL]

        return $obj
    }

    # Helper procedures
    proc getNULL {obj} { return [set ${obj}::NULL] }
    proc getRoot {obj} { return [set ${obj}::root] }
    proc setRoot {obj root} { set ${obj}::root $root }

    # Insert New Node
    proc insertNode {obj key} {
        set node [Node::new $key]
        Node::setParent $node ""
        Node::setVal $node $key
        Node::setLeft $node [getNULL $obj]
        Node::setRight $node [getNULL $obj]
        Node::setColor $node 1  ;# Set root colour as Red

        set y ""
        set x [getRoot $obj]

        # Find position for new node
        while {$x ne [getNULL $obj]} {
            set y $x
            if {[Node::getVal $node] < [Node::getVal $x]} {
                set x [Node::getLeft $x]
            } else {
                set x [Node::getRight $x]
            }
        }

        Node::setParent $node $y  ;# Set parent of Node as y

        if {$y eq ""} {  ;# If parent is none then it is root node
            setRoot $obj $node
        } elseif {[Node::getVal $node] < [Node::getVal $y]} {  ;# Check if it is right Node or Left Node
            Node::setLeft $y $node
        } else {
            Node::setRight $y $node
        }

        if {[Node::getParent $node] eq ""} {  ;# Root node is always Black
            Node::setColor $node 0
            return
        }

        if {[Node::getParent [Node::getParent $node]] eq ""} {  ;# If parent of node is Root Node
            return
        }

        fixInsert $obj $node  ;# Else call for Fix Up
    }

    # Find minimum node
    proc minimum {obj node} {
        while {[Node::getLeft $node] ne [getNULL $obj]} {
            set node [Node::getLeft $node]
        }
        return $node
    }

    # Code for left rotate
    proc LR {obj x} {
        set y [Node::getRight $x]  ;# Y = Right child of x
        Node::setRight $x [Node::getLeft $y]  ;# Change right child of x to left child of y

        if {[Node::getLeft $y] ne [getNULL $obj]} {
            Node::setParent [Node::getLeft $y] $x
        }

        Node::setParent $y [Node::getParent $x]  ;# Change parent of y as parent of x

        if {[Node::getParent $x] eq ""} {  ;# If parent of x == None ie. root node
            setRoot $obj $y  ;# Set y as root
        } elseif {$x eq [Node::getLeft [Node::getParent $x]]} {
            Node::setLeft [Node::getParent $x] $y
        } else {
            Node::setRight [Node::getParent $x] $y
        }

        Node::setLeft $y $x
        Node::setParent $x $y
    }

    # Code for right rotate
    proc RR {obj x} {
        set y [Node::getLeft $x]  ;# Y = Left child of x
        Node::setLeft $x [Node::getRight $y]  ;# Change left child of x to right child of y

        if {[Node::getRight $y] ne [getNULL $obj]} {
            Node::setParent [Node::getRight $y] $x
        }

        Node::setParent $y [Node::getParent $x]  ;# Change parent of y as parent of x

        if {[Node::getParent $x] eq ""} {  ;# If x is root node
            setRoot $obj $y  ;# Set y as root
        } elseif {$x eq [Node::getRight [Node::getParent $x]]} {
            Node::setRight [Node::getParent $x] $y
        } else {
            Node::setLeft [Node::getParent $x] $y
        }

        Node::setRight $y $x
        Node::setParent $x $y
    }

    # Fix Up Insertion
    proc fixInsert {obj k} {
        while {[Node::getColor [Node::getParent $k]] == 1} {  ;# While parent is red
            if {[Node::getParent $k] eq [Node::getRight [Node::getParent [Node::getParent $k]]]} {
                # if parent is right child of its parent
                set u [Node::getLeft [Node::getParent [Node::getParent $k]]]  ;# Left child of grandparent

                if {[Node::getColor $u] == 1} {  ;# if color of left child of grandparent i.e, uncle node is red
                    Node::setColor $u 0  ;# Set both children of grandparent node as black
                    Node::setColor [Node::getParent $k] 0
                    Node::setColor [Node::getParent [Node::getParent $k]] 1  ;# Set grandparent node as Red
                    set k [Node::getParent [Node::getParent $k]]  ;# Repeat the algo with Parent node to check conflicts
                } else {
                    if {$k eq [Node::getLeft [Node::getParent $k]]} {  ;# If k is left child of it's parent
                        set k [Node::getParent $k]
                        RR $obj $k  ;# Call for right rotation
                    }
                    Node::setColor [Node::getParent $k] 0
                    Node::setColor [Node::getParent [Node::getParent $k]] 1
                    LR $obj [Node::getParent [Node::getParent $k]]
                }
            } else {  ;# if parent is left child of its parent
                set u [Node::getRight [Node::getParent [Node::getParent $k]]]  ;# Right child of grandparent

                if {[Node::getColor $u] == 1} {  ;# if color of right child of grandparent i.e, uncle node is red
                    Node::setColor $u 0  ;# Set color of childs as black
                    Node::setColor [Node::getParent $k] 0
                    Node::setColor [Node::getParent [Node::getParent $k]] 1  ;# set color of grandparent as Red
                    set k [Node::getParent [Node::getParent $k]]  ;# Repeat algo on grandparent to remove conflicts
                } else {
                    if {$k eq [Node::getRight [Node::getParent $k]]} {  ;# if k is right child of its parent
                        set k [Node::getParent $k]
                        LR $obj $k  ;# Call left rotate on parent of k
                    }
                    Node::setColor [Node::getParent $k] 0
                    Node::setColor [Node::getParent [Node::getParent $k]] 1
                    RR $obj [Node::getParent [Node::getParent $k]]  ;# Call right rotate on grandparent
                }
            }

            if {$k eq [getRoot $obj]} {  ;# If k reaches root then break
                break
            }
        }

        Node::setColor [getRoot $obj] 0  ;# Set color of root as black
    }

    # Function to fix issues after deletion
    proc fixDelete {obj x} {
        while {$x ne [getRoot $obj] && [Node::getColor $x] == 0} {
            # Repeat until x reaches nodes and color of x is black
            if {$x eq [Node::getLeft [Node::getParent $x]]} {  ;# If x is left child of its parent
                set s [Node::getRight [Node::getParent $x]]  ;# Sibling of x

                if {[Node::getColor $s] == 1} {  ;# if sibling is red
                    Node::setColor $s 0  ;# Set its color to black
                    Node::setColor [Node::getParent $x] 1  ;# Make its parent red
                    LR $obj [Node::getParent $x]  ;# Call for left rotate on parent of x
                    set s [Node::getRight [Node::getParent $x]]
                }

                # If both the child are black
                if {[Node::getColor [Node::getLeft $s]] == 0 && [Node::getColor [Node::getRight $s]] == 0} {
                    Node::setColor $s 1  ;# Set color of s as red
                    set x [Node::getParent $x]
                } else {
                    if {[Node::getColor [Node::getRight $s]] == 0} {  ;# If right child of s is black
                        Node::setColor [Node::getLeft $s] 0  ;# set left child of s as black
                        Node::setColor $s 1  ;# set color of s as red
                        RR $obj $s  ;# call right rotation on x
                        set s [Node::getRight [Node::getParent $x]]
                    }
                    Node::setColor $s [Node::getColor [Node::getParent $x]]
                    Node::setColor [Node::getParent $x] 0  ;# Set parent of x as black
                    Node::setColor [Node::getRight $s] 0
                    LR $obj [Node::getParent $x]  ;# call left rotation on parent of x
                    set x [getRoot $obj]
                }
            } else {  ;# If x is right child of its parent
                set s [Node::getLeft [Node::getParent $x]]  ;# Sibling of x

                if {[Node::getColor $s] == 1} {  ;# if sibling is red
                    Node::setColor $s 0  ;# Set its color to black
                    Node::setColor [Node::getParent $x] 1  ;# Make its parent red
                    RR $obj [Node::getParent $x]  ;# Call for right rotate on parent of x
                    set s [Node::getLeft [Node::getParent $x]]
                }

                if {[Node::getColor [Node::getRight $s]] == 0 && [Node::getColor [Node::getLeft $s]] == 0} {
                    Node::setColor $s 1
                    set x [Node::getParent $x]
                } else {
                    if {[Node::getColor [Node::getLeft $s]] == 0} {  ;# If left child of s is black
                        Node::setColor [Node::getRight $s] 0  ;# set right child of s as black
                        Node::setColor $s 1
                        LR $obj $s  ;# call left rotation on x
                        set s [Node::getLeft [Node::getParent $x]]
                    }
                    Node::setColor $s [Node::getColor [Node::getParent $x]]
                    Node::setColor [Node::getParent $x] 0
                    Node::setColor [Node::getLeft $s] 0
                    RR $obj [Node::getParent $x]
                    set x [getRoot $obj]
                }
            }
        }

        Node::setColor $x 0
    }

    # Function to transplant nodes
    proc rb_transplant {obj u v} {
        if {[Node::getParent $u] eq ""} {
            setRoot $obj $v
        } elseif {$u eq [Node::getLeft [Node::getParent $u]]} {
            Node::setLeft [Node::getParent $u] $v
        } else {
            Node::setRight [Node::getParent $u] $v
        }
        Node::setParent $v [Node::getParent $u]
    }

    # Function to handle deletions
    proc delete_node_helper {obj node key} {
        set z [getNULL $obj]

        # Search for the node having that value/key and store it in 'z'
        while {$node ne [getNULL $obj]} {
            if {[Node::getVal $node] == $key} {
                set z $node
            }
            if {[Node::getVal $node] <= $key} {
                set node [Node::getRight $node]
            } else {
                set node [Node::getLeft $node]
            }
        }

        if {$z eq [getNULL $obj]} {  ;# If Key is not present then deletion not possible so return
            puts "Value not present in Tree !!"
            return
        }

        set y $z
        set y_original_color [Node::getColor $y]  ;# Store the color of z-node

        if {[Node::getLeft $z] eq [getNULL $obj]} {  ;# If left child of z is NULL
            set x [Node::getRight $z]  ;# Assign right child of z to x
            rb_transplant $obj $z [Node::getRight $z]  ;# Transplant Node to be deleted with x
        } elseif {[Node::getRight $z] eq [getNULL $obj]} {  ;# If right child of z is NULL
            set x [Node::getLeft $z]  ;# Assign left child of z to x
            rb_transplant $obj $z [Node::getLeft $z]  ;# Transplant Node to be deleted with x
        } else {  ;# If z has both the child nodes
            set y [minimum $obj [Node::getRight $z]]  ;# Find minimum of the right sub tree
            set y_original_color [Node::getColor $y]  ;# Store color of y
            set x [Node::getRight $y]

            if {[Node::getParent $y] eq $z} {  ;# If y is child of z
                Node::setParent $x $y  ;# Set parent of x as y
            } else {
                rb_transplant $obj $y [Node::getRight $y]
                Node::setRight $y [Node::getRight $z]
                Node::setParent [Node::getRight $y] $y
            }

            rb_transplant $obj $z $y
            Node::setLeft $y [Node::getLeft $z]
            Node::setParent [Node::getLeft $y] $y
            Node::setColor $y [Node::getColor $z]
        }

        if {$y_original_color == 0} {  ;# If color is black then fixing is needed
            fixDelete $obj $x
        }
    }

    # Deletion of node
    proc delete_node {obj val} {
        delete_node_helper $obj [getRoot $obj] $val  ;# Call for deletion
    }

    # Function to print
    proc printCall {obj node indent last} {
        if {$node ne [getNULL $obj]} {
            puts -nonewline $indent
            if {$last} {
                puts -nonewline "R----"
                append indent "     "
            } else {
                puts -nonewline "L----"
                append indent "|    "
            }

            set s_color [expr {[Node::getColor $node] == 1 ? "RED" : "BLACK"}]
            puts "[Node::getVal $node]($s_color)"
            printCall $obj [Node::getLeft $node] $indent 0
            printCall $obj [Node::getRight $node] $indent 1
        }
    }

    # Function to call print
    proc print_tree {obj} {
        printCall $obj [getRoot $obj] "" 1
    }
}

# Initialize counters
set ::nodeCounter 0
set ::treeCounter 0

# Main code
set bst [RBTree::new]

puts "State of the tree after inserting the 30 keys:"
for {set x 1} {$x <= 29} {incr x} {
    RBTree::insertNode $bst $x
}
RBTree::print_tree $bst

puts "\nState of the tree after deleting the 15 keys:"
for {set x 1} {$x <= 14} {incr x} {
    RBTree::delete_node $bst $x
}
RBTree::print_tree $bst
