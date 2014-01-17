note
	description : "Application for tree traversal demonstration"
        output      : "[
    	                Prints preorder, inorder, postorder and levelorder traversal of an example binary tree.
    		      ]"
	author	    : "Jascha Grübel"
	date        : "$2014-01-07$"
	revision    : "$1.0$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run Tree traversal example.
		local
			tree:NODE
		do
			create tree.make (1)
			tree.set_left_child (create {NODE}.make (2))
			tree.set_right_child (create {NODE}.make (3))
			tree.left_child.set_left_child (create {NODE}.make (4))
			tree.left_child.set_right_child (create {NODE}.make (5))
			tree.left_child.left_child.set_left_child (create {NODE}.make (7))
			tree.right_child.set_left_child (create {NODE}.make (6))
			tree.right_child.left_child.set_left_child (create {NODE}.make (8))
			tree.right_child.left_child.set_right_child (create {NODE}.make (9))

			Io.put_string ("preorder:   ")
			tree.print_preorder
			Io.put_new_line

			Io.put_string ("inorder:    ")
			tree.print_inorder
			Io.put_new_line

			Io.put_string ("postorder:  ")
			tree.print_postorder
			Io.put_new_line
			
			Io.put_string ("level-order:")
			tree.print_levelorder
			Io.put_new_line

		end

end -- class APPLICATION
