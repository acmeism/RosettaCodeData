val test = [
  ["interspecies", "interstellar", "interstate"],
  ["throne", "throne"],
  ["throne", "dungeon"],
  ["throne", "", "throne"],
  ["cheese"],
  [""],
  [],
  ["prefix", "suffix"],
  ["foo", "foobar"]
]

val () = (print o concat o map (fn lst => "'" ^ lcp lst ^ "'\n")) test
