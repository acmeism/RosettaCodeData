class HUFFMAN_NODE[T -> COMPARABLE]
inherit
	COMPARABLE
	redefine
		three_way_comparison
	end
create
	leaf_node, inner_node
feature {NONE}
	leaf_node (a_probability: REAL_64; a_value: T)
	do
		probability := a_probability
		value := a_value
		is_leaf := true

		left := void
		right := void
		parent := void
	end

	inner_node (a_left, a_right: HUFFMAN_NODE[T])
	do
		left := a_left
		right := a_right

		a_left.parent := Current
		a_right.parent := Current
		a_left.is_zero := true
		a_right.is_zero := false

		probability := a_left.probability + a_right.probability
		is_leaf := false
	end

feature
	probability: REAL_64
	value: detachable T


	is_leaf: BOOLEAN
	is_zero: BOOLEAN assign set_is_zero

	set_is_zero (a_value: BOOLEAN)
	do
		is_zero := a_value
	end

	left: detachable HUFFMAN_NODE[T]
	right: detachable HUFFMAN_NODE[T]
	parent: detachable HUFFMAN_NODE[T] assign set_parent

	set_parent (a_parent: detachable HUFFMAN_NODE[T])
	do
		parent := a_parent
	end

	is_root: BOOLEAN
	do
		Result := parent = void
	end

	bit_value: INTEGER
	do
		if is_zero then
			Result := 0
		else
			Result := 1
		end
	end
feature -- comparable implementation
	is_less alias "<" (other: like Current): BOOLEAN
	do
		Result := three_way_comparison (other) = -1
	end

	three_way_comparison (other: like Current): INTEGER
	do
		Result := -probability.three_way_comparison (other.probability)
	end
end

class HUFFMAN
create
	make
feature {NONE}
	make(a_string: STRING)
	require
		non_empty_string: a_string.count > 0
	local
		l_queue: HEAP_PRIORITY_QUEUE[HUFFMAN_NODE[CHARACTER]]
		l_counts: HASH_TABLE[INTEGER, CHARACTER]
		l_node: HUFFMAN_NODE[CHARACTER]
		l_left, l_right: HUFFMAN_NODE[CHARACTER]
	do
		create l_queue.make (a_string.count)
		create l_counts.make (10)

		across a_string as  char
		loop
			if not l_counts.has (char.item) then
				l_counts.put (0, char.item)
			end
			l_counts.replace (l_counts.at (char.item) + 1, char.item)
		end

		create leaf_dictionary.make(l_counts.count)

		across l_counts as kv
		loop
			create l_node.leaf_node ((kv.item * 1.0) / a_string.count, kv.key)
			l_queue.put (l_node)
			leaf_dictionary.put (l_node, kv.key)
		end

		from
		until
			l_queue.count <= 1
		loop
			l_left := l_queue.item
			l_queue.remove
			l_right := l_queue.item
			l_queue.remove

			create l_node.inner_node (l_left, l_right)
			l_queue.put (l_node)
		end

		root := l_queue.item
		root.is_zero := false
	end
feature
	root: HUFFMAN_NODE[CHARACTER]
	leaf_dictionary: HASH_TABLE[HUFFMAN_NODE[CHARACTER], CHARACTER]

	encode(a_value: CHARACTER): STRING
	require
		encodable: leaf_dictionary.has (a_value)
	local
		l_node: HUFFMAN_NODE[CHARACTER]
	do
		Result := ""
		if attached  leaf_dictionary.item (a_value) as attached_node then
			l_node := attached_node
			from

			until
				l_node.is_root
			loop
				Result.append_integer (l_node.bit_value)
				if attached l_node.parent as parent then
					l_node := parent
				end
			end

			Result.mirror
		end
	end
end

class
	APPLICATION
create
	make

feature {NONE}
	make -- entry point
	local
		l_str: STRING
		huff: HUFFMAN
		chars: BINARY_SEARCH_TREE_SET[CHARACTER]
	do
		l_str := "this is an example for huffman encoding"

		create huff.make (l_str)

		create chars.make
		chars.fill (l_str)

		from
			chars.start
		until
			chars.off
		loop
			print (chars.item.out + ": " + huff.encode (chars.item) + "%N")
			chars.forth
		end
	end
end
