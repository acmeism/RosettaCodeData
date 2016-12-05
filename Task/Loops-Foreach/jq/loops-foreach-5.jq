 {"a":1, "b":2} | . as $o | keys | map( [., $o[.]] )
