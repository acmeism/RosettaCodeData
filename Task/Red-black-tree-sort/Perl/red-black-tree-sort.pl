#!/usr/bin/perl
use strict;
use warnings;

# Define Node package
package Node;
sub new {
    my ($class, $val) = @_;
    my $self = {
        val    => $val,       # Value of Node
        parent => undef,      # Parent of Node
        left   => undef,      # Left Child of Node
        right  => undef,      # Right Child of Node
        color  => 1,          # Red Node as new node is always inserted as Red Node
    };
    bless $self, $class;
    return $self;
}

# Define RBTree package
package RBTree;
sub new {
    my ($class) = @_;
    my $self = {
        NULL => Node->new(0),
        root => undef,
    };
    $self->{NULL}->{color} = 0;
    $self->{NULL}->{left}  = undef;
    $self->{NULL}->{right} = undef;
    $self->{root} = $self->{NULL};
    bless $self, $class;
    return $self;
}

# Insert New Node
sub insertNode {
    my ($self, $key) = @_;
    my $node = Node->new($key);
    $node->{parent} = undef;
    $node->{val}    = $key;
    $node->{left}   = $self->{NULL};
    $node->{right}  = $self->{NULL};
    $node->{color}  = 1;    # Set root colour as Red
    my $y = undef;
    my $x = $self->{root};
    while ($x != $self->{NULL}) {    # Find position for new node
        $y = $x;
        if ($node->{val} < $x->{val}) {
            $x = $x->{left};
        } else {
            $x = $x->{right};
        }
    }
    $node->{parent} = $y;    # Set parent of Node as y
    if (!defined $y) {       # If parent is none then it is root node
        $self->{root} = $node;
    } elsif ($node->{val} < $y->{val}) {    # Check if it is right Node or Left Node by checking the value
        $y->{left} = $node;
    } else {
        $y->{right} = $node;
    }
    if (!defined $node->{parent}) {    # Root node is always Black
        $node->{color} = 0;
        return;
    }
    if (!defined $node->{parent}->{parent}) {    # If parent of node is Root Node
        return;
    }
    $self->fixInsert($node);    # Else call for Fix Up
}

# Find minimum node
sub minimum {
    my ($self, $node) = @_;
    while ($node->{left} != $self->{NULL}) {
        $node = $node->{left};
    }
    return $node;
}

# Code for left rotate
sub LR {
    my ($self, $x) = @_;
    my $y = $x->{right};    # Y = Right child of x
    $x->{right} = $y->{left};    # Change right child of x to left child of y
    if ($y->{left} != $self->{NULL}) {
        $y->{left}->{parent} = $x;
    }
    $y->{parent} = $x->{parent};    # Change parent of y as parent of x
    if (!defined $x->{parent}) {    # If parent of x == None ie. root node
        $self->{root} = $y;         # Set y as root
    } elsif ($x == $x->{parent}->{left}) {
        $x->{parent}->{left} = $y;
    } else {
        $x->{parent}->{right} = $y;
    }
    $y->{left} = $x;
    $x->{parent} = $y;
}

# Code for right rotate
sub RR {
    my ($self, $x) = @_;
    my $y = $x->{left};    # Y = Left child of x
    $x->{left} = $y->{right};    # Change left child of x to right child of y
    if ($y->{right} != $self->{NULL}) {
        $y->{right}->{parent} = $x;
    }
    $y->{parent} = $x->{parent};    # Change parent of y as parent of x
    if (!defined $x->{parent}) {    # If x is root node
        $self->{root} = $y;         # Set y as root
    } elsif ($x == $x->{parent}->{right}) {
        $x->{parent}->{right} = $y;
    } else {
        $x->{parent}->{left} = $y;
    }
    $y->{right} = $x;
    $x->{parent} = $y;
}

# Fix Up Insertion
sub fixInsert {
    my ($self, $k) = @_;
    while ($k->{parent}->{color} == 1) {    # While parent is red
        if ($k->{parent} == $k->{parent}->{parent}->{right}) {    # if parent is right child of its parent
            my $u = $k->{parent}->{parent}->{left};    # Left child of grandparent
            if ($u->{color} == 1) {    # if color of left child of grandparent i.e, uncle node is red
                $u->{color} = 0;      # Set both children of grandparent node as black
                $k->{parent}->{color} = 0;
                $k->{parent}->{parent}->{color} = 1;    # Set grandparent node as Red
                $k = $k->{parent}->{parent};    # Repeat the algo with Parent node to check conflicts
            } else {
                if ($k == $k->{parent}->{left}) {    # If k is left child of it's parent
                    $k = $k->{parent};
                    $self->RR($k);    # Call for right rotation
                }
                $k->{parent}->{color} = 0;
                $k->{parent}->{parent}->{color} = 1;
                $self->LR($k->{parent}->{parent});
            }
        } else {    # if parent is left child of its parent
            my $u = $k->{parent}->{parent}->{right};    # Right child of grandparent
            if ($u->{color} == 1) {    # if color of right child of grandparent i.e, uncle node is red
                $u->{color} = 0;      # Set color of childs as black
                $k->{parent}->{color} = 0;
                $k->{parent}->{parent}->{color} = 1;    # set color of grandparent as Red
                $k = $k->{parent}->{parent};    # Repeat algo on grandparent to remove conflicts
            } else {
                if ($k == $k->{parent}->{right}) {    # if k is right child of its parent
                    $k = $k->{parent};
                    $self->LR($k);    # Call left rotate on parent of k
                }
                $k->{parent}->{color} = 0;
                $k->{parent}->{parent}->{color} = 1;
                $self->RR($k->{parent}->{parent});    # Call right rotate on grandparent
            }
        }
        if ($k == $self->{root}) {    # If k reaches root then break
            last;
        }
    }
    $self->{root}->{color} = 0;    # Set color of root as black
}

# Function to fix issues after deletion
sub fixDelete {
    my ($self, $x) = @_;
    while ($x != $self->{root} && $x->{color} == 0) {    # Repeat until x reaches nodes and color of x is black
        if ($x == $x->{parent}->{left}) {    # If x is left child of its parent
            my $s = $x->{parent}->{right};    # Sibling of x
            if ($s->{color} == 1) {    # if sibling is red
                $s->{color} = 0;      # Set its color to black
                $x->{parent}->{color} = 1;    # Make its parent red
                $self->LR($x->{parent});    # Call for left rotate on parent of x
                $s = $x->{parent}->{right};
            }
            # If both the child are black
            if ($s->{left}->{color} == 0 && $s->{right}->{color} == 0) {
                $s->{color} = 1;    # Set color of s as red
                $x = $x->{parent};
            } else {
                if ($s->{right}->{color} == 0) {    # If right child of s is black
                    $s->{left}->{color} = 0;    # set left child of s as black
                    $s->{color} = 1;           # set color of s as red
                    $self->RR($s);             # call right rotation on x
                    $s = $x->{parent}->{right};
                }
                $s->{color} = $x->{parent}->{color};
                $x->{parent}->{color} = 0;    # Set parent of x as black
                $s->{right}->{color} = 0;
                $self->LR($x->{parent});    # call left rotation on parent of x
                $x = $self->{root};
            }
        } else {    # If x is right child of its parent
            my $s = $x->{parent}->{left};    # Sibling of x
            if ($s->{color} == 1) {    # if sibling is red
                $s->{color} = 0;      # Set its color to black
                $x->{parent}->{color} = 1;    # Make its parent red
                $self->RR($x->{parent});    # Call for right rotate on parent of x
                $s = $x->{parent}->{left};
            }
            if ($s->{right}->{color} == 0 && $s->{right}->{color} == 0) {
                $s->{color} = 1;
                $x = $x->{parent};
            } else {
                if ($s->{left}->{color} == 0) {    # If left child of s is black
                    $s->{right}->{color} = 0;    # set right child of s as black
                    $s->{color} = 1;
                    $self->LR($s);    # call left rotation on x
                    $s = $x->{parent}->{left};
                }
                $s->{color} = $x->{parent}->{color};
                $x->{parent}->{color} = 0;
                $s->{left}->{color} = 0;
                $self->RR($x->{parent});
                $x = $self->{root};
            }
        }
    }
    $x->{color} = 0;
}

# Function to transplant nodes
sub __rb_transplant {
    my ($self, $u, $v) = @_;
    if (!defined $u->{parent}) {
        $self->{root} = $v;
    } elsif ($u == $u->{parent}->{left}) {
        $u->{parent}->{left} = $v;
    } else {
        $u->{parent}->{right} = $v;
    }
    $v->{parent} = $u->{parent};
}

# Function to handle deletion
sub delete_node_helper {
    my ($self, $node, $key) = @_;
    my $z = $self->{NULL};
    while ($node != $self->{NULL}) {    # Search for the node having that value/ key and store it in 'z'
        if ($node->{val} == $key) {
            $z = $node;
        }
        if ($node->{val} <= $key) {
            $node = $node->{right};
        } else {
            $node = $node->{left};
        }
    }
    if ($z == $self->{NULL}) {    # If Key is not present then deletion not possible so return
        print "Value not present in Tree !!\n";
        return;
    }
    my $y = $z;
    my $y_original_color = $y->{color};    # Store the color of z-node
    my $x;
    if ($z->{left} == $self->{NULL}) {    # If left child of z is NULL
        $x = $z->{right};    # Assign right child of z to x
        $self->__rb_transplant($z, $z->{right});    # Transplant Node to be deleted with x
    } elsif ($z->{right} == $self->{NULL}) {    # If right child of z is NULL
        $x = $z->{left};    # Assign left child of z to x
        $self->__rb_transplant($z, $z->{left});    # Transplant Node to be deleted with x
    } else {    # If z has both the child nodes
        $y = $self->minimum($z->{right});    # Find minimum of the right sub tree
        $y_original_color = $y->{color};    # Store color of y
        $x = $y->{right};
        if ($y->{parent} == $z) {    # If y is child of z
            $x->{parent} = $y;    # Set parent of x as y
        } else {
            $self->__rb_transplant($y, $y->{right});
            $y->{right} = $z->{right};
            $y->{right}->{parent} = $y;
        }
        $self->__rb_transplant($z, $y);
        $y->{left} = $z->{left};
        $y->{left}->{parent} = $y;
        $y->{color} = $z->{color};
    }
    if ($y_original_color == 0) {    # If color is black then fixing is needed
        $self->fixDelete($x);
    }
}

# Deletion of node
sub delete_node {
    my ($self, $val) = @_;
    $self->delete_node_helper($self->{root}, $val);    # Call for deletion
}

# Function to print
sub __printCall {
    my ($self, $node, $indent, $last) = @_;
    if ($node != $self->{NULL}) {
        print $indent;
        if ($last) {
            print "R----";
            $indent .= "     ";
        } else {
            print "L----";
            $indent .= "|    ";
        }
        my $s_color = ($node->{color} == 1) ? "RED" : "BLACK";
        print $node->{val} . "($s_color)\n";
        $self->__printCall($node->{left},  $indent, 0);
        $self->__printCall($node->{right}, $indent, 1);
    }
}

# Function to call print
sub print_tree {
    my ($self) = @_;
    $self->__printCall($self->{root}, "", 1);
}

# Main code
my $bst = RBTree->new();
print "State of the tree after inserting the 30 keys:\n";
for my $x (1..29) {
    $bst->insertNode($x);
}
$bst->print_tree();
print "\nState of the tree after deleting the 15 keys:\n";
for my $x (1..14) {
    $bst->delete_node($x);
}
$bst->print_tree();
