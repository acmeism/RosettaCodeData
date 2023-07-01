####################################################################################################
# Pool management.

# Pool of objects.
type
  Block[Size: static Positive, T] = ref array[Size, T]
  Pool[BlockSize: static Positive, T] = ref object
    blocks: seq[Block[BlockSize, T]]        # List of blocks.
    lastindex: int                          # Last object index in the last block.

#---------------------------------------------------------------------------------------------------

proc newPool(S: static Positive; T: typedesc): Pool[S, T] =
  ## Create a pool with blocks of "S" type "T" objects.

  new(result)
  result.blocks = @[new(Block[S, T])]
  result.lastindex = -1

#---------------------------------------------------------------------------------------------------

proc getItem(pool: Pool): ptr pool.T =
  ## Return a pointer on a node from the pool.

  inc pool.lastindex
  if pool.lastindex == pool.BlockSize:
    # Allocate a new block. It is initialized with zeroes.
    pool.blocks.add(new(Block[pool.BlockSize, pool.T]))
    pool.lastindex = 0
  result = cast[ptr pool.T](addr(pool.blocks[^1][pool.lastindex]))


####################################################################################################
# Example: use the pool to allocate nodes.

type

  # Node description.
  NodePtr = ptr Node
  Node = object
    value: int
    prev: NodePtr
    next: NodePtr

type NodePool = Pool[5000, Node]

proc newNode(pool: NodePool; value: int): NodePtr =
  ## Create a new node.

  result = pool.getItem()
  result.value = value
  result.prev = nil     # Not needed, allocated memory being initialized to 0.
  result.next = nil

proc test() =
  ## Build a circular list of nodes managed in a pool.

  let pool = newPool(NodePool.BlockSize, Node)
  var head = pool.newNode(0)
  var prev = head
  for i in 1..11999:
    let node = pool.newNode(i)
    node.prev = prev
    prev.next = node
  # Display information about the pool state.
  echo "Number of allocated blocks: ", pool.blocks.len
  echo "Number of nodes in the last block: ", pool.lastindex + 1

test()

# No need to free the pool. This is done automatically as it has been allocated by "new".
