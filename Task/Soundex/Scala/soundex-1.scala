def soundex(s:String)={
   var code=s.head.toUpper.toString
   var previous=getCode(code.head)
   for(ch <- s.drop(1); current=getCode(ch.toUpper)){
      if (!current.isEmpty && current!=previous)
         code+=current
      previous=current
   }
   code+="0000"
   code.slice(0,4)
}

def getCode(c:Char)={
   val code=Map("1"->List('B','F','P','V'),
      "2"->List('C','G','J','K','Q','S','X','Z'),
      "3"->List('D', 'T'),
      "4"->List('L'),
      "5"->List('M', 'N'),
      "6"->List('R'))

   code.find(_._2.exists(_==c)) match {
      case Some((k,_)) => k
      case _ => ""
   }
}
