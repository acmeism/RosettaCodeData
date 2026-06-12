	function textBetween(thisText, startString, endString)
	{
		if (thisText == undefined)
		{
			return "";
		}
		
		var start_pos = 0;
		if (startString != 'start')
		{
			start_pos = thisText.indexOf(startString);

			// If the text does not contain the start string, return a blank string
			if (start_pos < 0)
			{
				return '';
			}

			// Skip the first startString characters
			start_pos = start_pos + startString.length;
		}

		var end_pos = thisText.length;
		if (endString != 'end')
		{
			end_pos = thisText.indexOf(endString,start_pos);
		}

		// If the text does not have the end string after the start string, return the whole string after the start
		if (end_pos < start_pos)
		{
			end_pos = thisText.length;
		}

		var newText = thisText.substring(start_pos,end_pos);

		return newText;
	} // end textBetween
