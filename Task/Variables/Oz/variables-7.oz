if {IsEven 42} then
   {System.showInfo "Here, LocalVar is not visible."}
   local
      LocalVar = "Here, LocalVar IS visible"
   in
      {System.showInfo LocalVar}
   end
end
