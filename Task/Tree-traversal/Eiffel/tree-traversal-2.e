note
	description    : "A simple node for a binary tree"
        libraries      : "Relies on LINKED_LIST from EiffelBase"
	author         : "Jascha Grübel"
	date           : "$2014-01-07$"
	revision       : "$1.0$"
        implementation : "[
			   All traversals but the levelorder traversal have been implemented recursively.
                           The levelorder traversal is solved iteratively.
			 ]"

class
	NODE
create
	make

feature {NONE} -- Initialization

	make (a_value:INTEGER)
			-- Creates a node with no children.
		do
			value := a_value
			set_right_child(Void)
			set_left_child(Void)
		end

feature -- Modification

	set_right_child (a_node:NODE)
			-- Sets `right_child' to `a_node'.
		do
			right_child:=a_node
		end

	set_left_child (a_node:NODE)
			-- Sets `left_child' to `a_node'.
		do
			left_child:=a_node
		end

feature -- Representation

	print_preorder
			-- Recursively prints the value of the node and all its children in preorder
		do
			Io.put_string (" " + value.out)
			if has_left_child then
				left_child.print_preorder
			end
			if has_right_child then
				right_child.print_preorder
			end
		end

	print_inorder
			-- Recursively prints the value of the node and all its children in inorder
		do
			if has_left_child then
				left_child.print_inorder
			end
			Io.put_string (" " + value.out)
			if has_right_child then
				right_child.print_inorder
			end
		end

	print_postorder
			-- Recursively prints the value of the node and all its children in postorder
		do
			if has_left_child then
				left_child.print_postorder
			end
			if has_right_child then
				right_child.print_postorder
			end
			Io.put_string (" " + value.out)
		end

	print_levelorder
			-- Iteratively prints the value of the node and all its children in levelorder
		local
			l_linked_list:LINKED_LIST[NODE]
			l_node:NODE
		do
			from
				create l_linked_list.make
				l_linked_list.extend (Current)
			until
				l_linked_list.is_empty
			loop
				l_node := l_linked_list.first
				if l_node.has_left_child then
					l_linked_list.extend (l_node.left_child)
				end
				if l_node.has_right_child then
					l_linked_list.extend (l_node.right_child)
				end
				Io.put_string (" " + l_node.value.out)
				l_linked_list.prune (l_node)
			end
		end

feature -- Access

	value:INTEGER
			-- Value stored in the node.

	right_child:NODE
			-- Reference to right child, possibly void.

	left_child:NODE
			-- Reference to left child, possibly void.

	has_right_child:BOOLEAN
			-- Test right child for existence.
		do
			Result := right_child /= Void
		end

	has_left_child:BOOLEAN
			-- Test left child for existence.
		do
			Result := left_child /= Void
		end

end
 -- class NODE
