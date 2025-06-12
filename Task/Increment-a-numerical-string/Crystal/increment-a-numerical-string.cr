"-123".succ  # => "-124"

require "big"

"-123".to_big_i.succ.to_s  # => "-122"
