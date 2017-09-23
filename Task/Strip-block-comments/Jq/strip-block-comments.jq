def strip_block_comments(open; close):
  def deregex:
    reduce ("\\\\", "\\*", "\\^", "\\?", "\\+", "\\.",
            "\\!", "\\{", "\\}", "\\[", "\\]", "\\$", "\\|" ) as $c
      (.; gsub($c; $c));
  # "?" => reluctant, "m" => multiline
  gsub( (open|deregex) + ".*?" + (close|deregex); ""; "m") ;

strip_block_comments("/*"; "*/")
