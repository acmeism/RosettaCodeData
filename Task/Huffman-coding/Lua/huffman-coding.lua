local build_freqtable = function (data)
  local freq = { }

  for i = 1, #data do
    local cur = string.sub (data, i, i)
    local count = freq [cur] or 0
    freq [cur] = count + 1
  end

  local nodes = { }
  for w, f in next, freq do
    nodes [#nodes + 1] = { word = w, freq = f }
  end

  table.sort (nodes, function (a, b) return a.freq > b.freq end) --- reverse order!

  return nodes
end

local build_hufftree = function (nodes)
  while true do
    local n = #nodes
    local left = nodes [n]
    nodes [n] = nil

    local right = nodes [n - 1]
    nodes [n - 1] = nil

    local new = { freq = left.freq + right.freq, left = left, right = right }

    if n == 2 then return new end

    --- insert new node at correct priority
    local prio = 1
    while prio < #nodes and nodes [prio].freq > new.freq do
      prio = prio + 1
    end
    table.insert (nodes, prio, new)
  end
end

local print_huffcodes do
  local rec_build_huffcodes
  rec_build_huffcodes = function (node, bits, acc)
    if node.word == nil then
      rec_build_huffcodes (node.left,  bits .. "0", acc)
      rec_build_huffcodes (node.right, bits .. "1", acc)
      return acc
    else --- leaf
      acc [#acc + 1] = { node.freq, node.word, bits }
    end
    return acc
  end

  print_huffcodes = function (root)
    local codes = rec_build_huffcodes (root, "", { })
    table.sort (codes, function (a, b) return a [1] < b [1] end)
    print ("frequency\tword\thuffman code")
    for i = 1, #codes do
      print (string.format ("%9d\t‘%s’\t“%s”", table.unpack (codes [i])))
    end
  end
end


local huffcode = function (data)
  local nodes = build_freqtable (data)
  local huff = build_hufftree (nodes)
  print_huffcodes (huff)
  return 0
end

return huffcode "this is an example for huffman encoding"
