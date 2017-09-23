[range(0;1024) | [.] | implode | if @uri == . then . else empty end] | join(null)
