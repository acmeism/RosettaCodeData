@list.grep( -> $obj { $obj.substr(0,1).lc.match(/<[0..9 a..f]>/) } )
