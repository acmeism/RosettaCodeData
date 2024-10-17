f = fn ff,i -> :io.fwrite "~.8b~n", [i]; ff.(ff, i+1) end
f.(f, 0)
