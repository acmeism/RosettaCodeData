procedure DynMethod(obj,meth,arglist[])
   local m

   if not (type(obj) ? ( tab(find("__")), ="__state", pos(0))) then
      runerr(205,obj)                       # invalid value - not an object

   if meth == ("initially"|"UndefinedMethod") then fail  # avoid protected

   m := obj.__m                                          # get methods list
   if fieldnames(m) == meth then                         # method exists?
      return m[meth]!push(copy(arglist),obj)             # ... call it
   else
      if fieldnames(m) == "UndefinedMethod" then         # handler exists?
         return obj.UndefinedMethod!arglist              # ... call it
      else runerr(207,obj)                  # error invalid method (i.e. field)
end
