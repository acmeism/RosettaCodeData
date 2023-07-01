def makeList(separator):
  # input: {text: _, counter: _}
  def makeItem(item):
     (.counter + 1) as $counter
     | .text += "\($counter)\(separator)\(item)\n"
     | .counter = $counter;

   {text:"", counter:0} | makeItem("first") | makeItem("second") | makeItem("third")
   | .text
;

makeList(". ")
