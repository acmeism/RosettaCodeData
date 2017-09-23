$ jq -n -f Strip_whitespace_top_tail.jq
"lstrip: String with spaces \t  \r  \n  "
"rstrip:  \t \r \n String with spaces"
"strip: String with spaces"
"rstrip: \u0001 <- control A"
"strip: <- control A"
"lstrip: <- ^A ^B"
"rstrip: \u0001 \u0002 <- ^A ^B"
"strip: <- ^A ^B"
