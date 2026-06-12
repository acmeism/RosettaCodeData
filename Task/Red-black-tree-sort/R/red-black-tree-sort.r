library(R6)

# Define Node class
Node <- R6Class("Node",
  public = list(
    val = NULL,
    parent = NULL,
    left = NULL,
    right = NULL,
    color = NULL,

    initialize = function(val) {
      self$val <- val
      self$parent <- NULL
      self$left <- NULL
      self$right <- NULL
      self$color <- 1  # Red Node as new node is always inserted as Red Node
    }
  )
)

# Define R-B Tree class
RBTree <- R6Class("RBTree",
  public = list(
    NULL_NODE = NULL,
    root = NULL,

    initialize = function() {
      self$NULL_NODE <- Node$new(0)
      self$NULL_NODE$color <- 0
      self$NULL_NODE$left <- NULL
      self$NULL_NODE$right <- NULL
      self$root <- self$NULL_NODE
    },

    # Insert New Node
    insertNode = function(key) {
      node <- Node$new(key)
      node$parent <- NULL
      node$val <- key
      node$left <- self$NULL_NODE
      node$right <- self$NULL_NODE
      node$color <- 1  # Set root colour as Red

      y <- NULL
      x <- self$root

      while (!identical(x, self$NULL_NODE)) {  # Find position for new node
        y <- x
        if (node$val < x$val) {
          x <- x$left
        } else {
          x <- x$right
        }
      }

      node$parent <- y  # Set parent of Node as y
      if (is.null(y)) {  # If parent is none then it is root node
        self$root <- node
      } else if (node$val < y$val) {  # Check if it is right Node or Left Node by checking the value
        y$left <- node
      } else {
        y$right <- node
      }

      if (is.null(node$parent)) {  # Root node is always Black
        node$color <- 0
        return(invisible(self))
      }

      if (is.null(node$parent$parent)) {  # If parent of node is Root Node
        return(invisible(self))
      }

      self$fixInsert(node)  # Else call for Fix Up
      return(invisible(self))
    },

    minimum = function(node) {
      while (!identical(node$left, self$NULL_NODE)) {
        node <- node$left
      }
      return(node)
    },

    # Code for left rotate
    LR = function(x) {
      y <- x$right  # Y = Right child of x
      x$right <- y$left  # Change right child of x to left child of y
      if (!identical(y$left, self$NULL_NODE)) {
        y$left$parent <- x
      }

      y$parent <- x$parent  # Change parent of y as parent of x
      if (is.null(x$parent)) {  # If parent of x == NULL ie. root node
        self$root <- y  # Set y as root
      } else if (identical(x, x$parent$left)) {
        x$parent$left <- y
      } else {
        x$parent$right <- y
      }
      y$left <- x
      x$parent <- y
    },

    # Code for right rotate
    RR = function(x) {
      y <- x$left  # Y = Left child of x
      x$left <- y$right  # Change left child of x to right child of y
      if (!identical(y$right, self$NULL_NODE)) {
        y$right$parent <- x
      }

      y$parent <- x$parent  # Change parent of y as parent of x
      if (is.null(x$parent)) {  # If x is root node
        self$root <- y  # Set y as root
      } else if (identical(x, x$parent$right)) {
        x$parent$right <- y
      } else {
        x$parent$left <- y
      }
      y$right <- x
      x$parent <- y
    },

    # Fix Up Insertion
    fixInsert = function(k) {
      while (k$parent$color == 1) {  # While parent is red
        if (identical(k$parent, k$parent$parent$right)) {  # if parent is right child of its parent
          u <- k$parent$parent$left  # Left child of grandparent
          if (u$color == 1) {  # if color of left child of grandparent i.e, uncle node is red
            u$color <- 0  # Set both children of grandparent node as black
            k$parent$color <- 0
            k$parent$parent$color <- 1  # Set grandparent node as Red
            k <- k$parent$parent  # Repeat the algo with Parent node to check conflicts
          } else {
            if (identical(k, k$parent$left)) {  # If k is left child of it's parent
              k <- k$parent
              self$RR(k)  # Call for right rotation
            }
            k$parent$color <- 0
            k$parent$parent$color <- 1
            self$LR(k$parent$parent)
          }
        } else {  # if parent is left child of its parent
          u <- k$parent$parent$right  # Right child of grandparent
          if (u$color == 1) {  # if color of right child of grandparent i.e, uncle node is red
            u$color <- 0  # Set color of childs as black
            k$parent$color <- 0
            k$parent$parent$color <- 1  # set color of grandparent as Red
            k <- k$parent$parent  # Repeat algo on grandparent to remove conflicts
          } else {
            if (identical(k, k$parent$right)) {  # if k is right child of its parent
              k <- k$parent
              self$LR(k)  # Call left rotate on parent of k
            }
            k$parent$color <- 0
            k$parent$parent$color <- 1
            self$RR(k$parent$parent)  # Call right rotate on grandparent
          }
        }
        if (identical(k, self$root)) {  # If k reaches root then break
          break
        }
      }
      self$root$color <- 0  # Set color of root as black
    },

    # Function to fix issues after deletion
    fixDelete = function(x) {
      while (!identical(x, self$root) && x$color == 0) {  # Repeat until x reaches nodes and color of x is black
        if (identical(x, x$parent$left)) {  # If x is left child of its parent
          s <- x$parent$right  # Sibling of x
          if (s$color == 1) {  # if sibling is red
            s$color <- 0  # Set its color to black
            x$parent$color <- 1  # Make its parent red
            self$LR(x$parent)  # Call for left rotate on parent of x
            s <- x$parent$right
          }
          # If both the child are black
          if (s$left$color == 0 && s$right$color == 0) {
            s$color <- 1  # Set color of s as red
            x <- x$parent
          } else {
            if (s$right$color == 0) {  # If right child of s is black
              s$left$color <- 0  # set left child of s as black
              s$color <- 1  # set color of s as red
              self$RR(s)  # call right rotation on x
              s <- x$parent$right
            }

            s$color <- x$parent$color
            x$parent$color <- 0  # Set parent of x as black
            s$right$color <- 0
            self$LR(x$parent)  # call left rotation on parent of x
            x <- self$root
          }
        } else {  # If x is right child of its parent
          s <- x$parent$left  # Sibling of x
          if (s$color == 1) {  # if sibling is red
            s$color <- 0  # Set its color to black
            x$parent$color <- 1  # Make its parent red
            self$RR(x$parent)  # Call for right rotate on parent of x
            s <- x$parent$left
          }

          if (s$right$color == 0 && s$left$color == 0) {
            s$color <- 1
            x <- x$parent
          } else {
            if (s$left$color == 0) {  # If left child of s is black
              s$right$color <- 0  # set right child of s as black
              s$color <- 1
              self$LR(s)  # call left rotation on x
              s <- x$parent$left
            }

            s$color <- x$parent$color
            x$parent$color <- 0
            s$left$color <- 0
            self$RR(x$parent)
            x <- self$root
          }
        }
      }
      x$color <- 0
    },

    # Function to transplant nodes
    rb_transplant = function(u, v) {
      if (is.null(u$parent)) {
        self$root <- v
      } else if (identical(u, u$parent$left)) {
        u$parent$left <- v
      } else {
        u$parent$right <- v
      }
      v$parent <- u$parent
    },

    # Function to handle deletion
    delete_node_helper = function(node, key) {
      z <- self$NULL_NODE
      while (!identical(node, self$NULL_NODE)) {  # Search for the node having that value/ key and store it in 'z'
        if (node$val == key) {
          z <- node
        }

        if (node$val <= key) {
          node <- node$right
        } else {
          node <- node$left
        }
      }

      if (identical(z, self$NULL_NODE)) {  # If Key is not present then deletion not possible so return
        cat("Value not present in Tree !!\n")
        return(invisible(self))
      }

      y <- z
      y_original_color <- y$color  # Store the color of z- node
      if (identical(z$left, self$NULL_NODE)) {  # If left child of z is NULL
        x <- z$right  # Assign right child of z to x
        self$rb_transplant(z, z$right)  # Transplant Node to be deleted with x
      } else if (identical(z$right, self$NULL_NODE)) {  # If right child of z is NULL
        x <- z$left  # Assign left child of z to x
        self$rb_transplant(z, z$left)  # Transplant Node to be deleted with x
      } else {  # If z has both the child nodes
        y <- self$minimum(z$right)  # Find minimum of the right sub tree
        y_original_color <- y$color  # Store color of y
        x <- y$right
        if (identical(y$parent, z)) {  # If y is child of z
          x$parent <- y  # Set parent of x as y
        } else {
          self$rb_transplant(y, y$right)
          y$right <- z$right
          y$right$parent <- y
        }

        self$rb_transplant(z, y)
        y$left <- z$left
        y$left$parent <- y
        y$color <- z$color
      }
      if (y_original_color == 0) {  # If color is black then fixing is needed
        self$fixDelete(x)
      }
      return(invisible(self))
    },

    # Deletion of node
    delete_node = function(val) {
      self$delete_node_helper(self$root, val)  # Call for deletion
      return(invisible(self))
    },

    # Function to print
    printCall = function(node, indent, last) {
      if (!identical(node, self$NULL_NODE)) {
        cat(indent)
        if (last) {
          cat("R---- ")
          indent <- paste0(indent, "     ")
        } else {
          cat("L---- ")
          indent <- paste0(indent, "|    ")
        }

        s_color <- if (node$color == 1) "RED" else "BLACK"
        cat(paste0(node$val, "(", s_color, ")\n"))
        self$printCall(node$left, indent, FALSE)
        self$printCall(node$right, indent, TRUE)
      }
    },

    # Function to call print
    print_tree = function() {
      self$printCall(self$root, "", TRUE)
      return(invisible(self))
    }
  )
)

# Example usage
bst <- RBTree$new()

cat("State of the tree after inserting the 30 keys:\n")
for (x in 1:29) {
  bst$insertNode(x)
}
bst$print_tree()

cat("\nState of the tree after deleting the 15 keys:\n")
for (x in 1:14) {
  bst$delete_node(x)
}
bst$print_tree()
