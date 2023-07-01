require "benchmark"

struct Document
  property :id
  def initialize(@id : Int32) end
end

documents_a = [] of Int32 | Document
documents_h = {} of Int32 => Int32 | Document

1.upto(10_000) do |n|
  d = Document.new(n)
  documents_a << d
  documents_h[d.id] = d
end

searchlist = Array.new(1000){ rand(10_000)+1 }

Benchmark.bm do |x|
  x.report("array"){searchlist.each{ |el| documents_a.any?{ |d| d == el }} }
  x.report("hash") {searchlist.each{ |el| documents_h.has_key?(el) } }
end
puts
Benchmark.ips do |x|
  x.report("array"){searchlist.each{ |el| documents_a.any?{ |d| d == el }} }
  x.report("hash") {searchlist.each{ |el| documents_h.has_key?(el) } }
end
