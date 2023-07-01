declare
  proc {Main}
   DOM = root(element("Some text here"))
  in
     {System.showInfo {Serialize DOM}}
  end
  ...
