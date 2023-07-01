procedure main()
   every dir := "." | "./empty" do
      write(dir, if isdirempty(dir) then " is empty" else " is not empty")
end

procedure isdirempty(s)  #: succeeds if directory s is empty (and a directory)
local d,f
   if ( stat(s).mode ? ="d" ) & ( d := open(s) ) then {
         while f := read(d) do
            if f == ("."|"..") then next else fail
         close(d)
         return s
         }
   else stop(s," is not a directory or will not open")
end
