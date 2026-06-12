class String
  def textBetween startDelimiter, endDelimiter

  	if (startDelimiter == "start") then
  		startIndex = 0
  	else
  		startIndex = self.index(startDelimiter) + startDelimiter.length
  	end
  	
  	if (startIndex == nil) then
  		return "Start delimiter not found"
  	end
  	
  	thisLength = self.length
  	
  	returnText = self[startIndex, thisLength]
  	  	
 	if (endDelimiter == "end") then
  		endIndex = thisLength
  	else
  		endIndex = returnText.index(endDelimiter)
  	end
  	
  	if (endIndex == nil) then
  		return "End delimiter not found"
  	end
  	  	
  	returnText = returnText[0, endIndex]
  	
  	return returnText

  end
end

thisText = ARGV[0]
startDelimiter = ARGV[1]
endDelimiter = ARGV[2]

#puts thisText
#puts startDelimiter
#puts endDelimiter

returnText = thisText.textBetween(startDelimiter, endDelimiter)

puts returnText
