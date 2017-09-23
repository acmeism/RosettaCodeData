// Both of the following declarations can be seen as a tree,
// var -> <varname>
var/x
var y

// They can also be defined like this.
// This is once again a tree structure, but this time the "var" only appears once, and the x and y are children.
var
    x
    y
// And like this, still a tree structure.
var/x, y
