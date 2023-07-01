import Utils  # for buildStackTrace

procedure main()
   g()
   write()
   f()
end

procedure f()
   g()
end

procedure g()
   # Using 1 as argument omits the trace of buildStackTrace itself
   every write("\t",!buildStackTrace(1))
end
