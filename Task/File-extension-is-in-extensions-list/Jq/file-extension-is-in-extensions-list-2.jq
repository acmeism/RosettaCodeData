("c:", "txt", "text.txt", "text.TXT", "foo.c", "foo.C++", "document.pdf")
| has_extension([".txt", ".c"]) as $ext
| if $ext then "\(.) has extension \($ext)"
  else "\"\(.)\" does not have an admissible file extension"
  end
