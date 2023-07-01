class Singleton
   method print()
       write("Hi there.")
   end
   initially
       write("In constructor!")
       Singleton := create |self
end

procedure main()
   Singleton().print()
   Singleton().print()
end
