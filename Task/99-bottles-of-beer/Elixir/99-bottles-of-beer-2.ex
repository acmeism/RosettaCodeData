last = [
  """
  2 bottles of beer on the wall
  2 bottles of beer
  Take one down, pass it around
  1 bottle of beer on the wall
  """,
  """
  1 bottle of beer on the wall
  1 bottle of beer
  Take one down, pass it around
  No bottles of beer on the wall
  """,
  """
  No more bottles of beer on the wall
  No more bottles of beer
  Go to the store and buy some more
  99 bottles of beer on the wall
  """
]

skeleton = fn n ->
  """
  #{n} bottles of beer on the wall
  #{n} bottles of beer
  Take one down, pass it around
  #{n - 1} bottles of beer on the wall
  """
end

99..3
|> Stream.map(skeleton)
|> Stream.concat(last)
|> Enum.intersperse("\n")
|> IO.iodata_to_binary()
|> IO.puts()
