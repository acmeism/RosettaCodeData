let
  fun inf_loop () = (
    print "SPAM\n";
    inf_loop ()
  )
in
  inf_loop ()
end
