begin proc(string)string getenv = nest C "getenv";
      puts(getenv("HOME") + "'n")
end
