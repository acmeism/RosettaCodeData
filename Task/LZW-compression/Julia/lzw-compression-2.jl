""" Trie node struct """
mutable struct TrieNode{T}
   children::Vector{Int} # child node indices (0 = none)
   code::T # LZW code for this node's phrase
end
TrieNode(code::Int) = TrieNode{Int}(zeros(Int, 256), code)

""" LZW compression """
function compressLZW(input::Vector{UInt8})
   if isempty(input)
      return Int[]
   end
   nodes = [TrieNode(i) for i in 0:255]
   push!(nodes, TrieNode(-1))
   root = length(nodes)  # == 257
   @inbounds for b in 0:255
      nodes[root].children[b+1] = b + 1 # initialize root children
   end

   sizehint!(nodes, length(input) + root)
   result = Int[]
   sizehint!(result, length(input))
   dictsize = 256  # next code to assign
   current = nodes[root].children[input[1]+1] # guaranteed to exist
   @inbounds for i in 2:length(input)
      c = input[i]
      nxt = nodes[current].children[c+1]
      if nxt != 0
         current = nxt
      else
         push!(result, nodes[current].code)
         dictsize += 1
         push!(nodes, TrieNode(dictsize - 1))
         new_idx = length(nodes)
         nodes[current].children[c+1] = new_idx
         current = nodes[root].children[c+1]
      end
   end
   push!(result, nodes[current].code) # add last remaining
   return result
end

""" LZW decompression """
function decompressLZW(compressed::Vector{Int})
   isempty(compressed) && return UInt8[]
   dict = [[UInt8(i)] for i in 0:255]
   dictsize = 256
   w = copy(dict[compressed[1]+1])
   output = copy(w)
   @inbounds for k in Iterators.drop(compressed, 1)
      entry = k + 1 <= length(dict) ? dict[k+1] :
           k == dictsize ? vcat(w, w[1]) : error("Bad compressed code: $k")
      append!(output, entry)
      push!(dict, vcat(w, entry[1]))
      dictsize += 1
      w = entry
   end
   return output
end

const texts = ["0123456789", "TOBEORNOTTOBEORTOBEORNOT", "dudidudidudida"]
const inputs = [Vector{UInt8}(t) for t in texts]

const compressed   = compressLZW.(inputs)
const decompressed = decompressLZW.(compressed)

for (orig, comp, decomp) in zip(texts, compressed, decompressed)
   comprate = (length(orig) - length(comp)) / length(orig) * 100
   println("Original: $orig")
   println("→ Compressed: $comp (rate: $(round(comprate, digits=2))%)")
   println("→ Decompressed: $(String(decomp))\n")
end
