huffman_encoding_table = (counts) ->
  # counts is a hash where keys are characters and
  # values are frequencies;
  # return a hash where keys are codes and values
  # are characters

  build_huffman_tree = ->
    # returns a Huffman tree.  Each node has
    #   cnt: total frequency of all chars in subtree
    #   c: character to be encoded (leafs only)
    #   children: children nodes (branches only)
    q = min_queue()
    for c, cnt of counts
      q.enqueue cnt,
        cnt: cnt
        c: c
    while q.size() >= 2
      a = q.dequeue()
      b = q.dequeue()
      cnt = a.cnt + b.cnt
      node =
        cnt: cnt
        children: [a, b]
      q.enqueue cnt, node
    root = q.dequeue()

  root = build_huffman_tree()

  codes = {}
  encode = (node, code) ->
    if node.c?
      codes[code] = node.c
    else
      encode node.children[0], code + "0"
      encode node.children[1], code + "1"

  encode(root, "")
  codes

min_queue = ->
  # This is very non-optimized; you could use a binary heap for better
  # performance.  Items with smaller priority get dequeued first.
  arr = []
  enqueue: (priority, data) ->
    i = 0
    while i < arr.length
      if priority < arr[i].priority
        break
      i += 1
    arr.splice i, 0,
      priority: priority
      data: data
  dequeue: ->
    arr.shift().data
  size: -> arr.length
  _internal: ->
    arr

freq_count = (s) ->
  cnts = {}
  for c in s
    cnts[c] ?= 0
    cnts[c] += 1
  cnts

rpad = (s, n) ->
  while s.length < n
    s += ' '
  s

examples = [
  "this is an example for huffman encoding"
  "abcd"
  "abbccccddddddddeeeeeeeee"
]

for s in examples
  console.log "---- #{s}"
  counts = freq_count(s)
  huffman_table = huffman_encoding_table(counts)
  codes = (code for code of huffman_table).sort()
  for code in codes
    c = huffman_table[code]
    console.log "#{rpad(code, 5)}: #{c} (#{counts[c]})"
  console.log()
