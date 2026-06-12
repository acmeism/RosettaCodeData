/*
 * textBetween: Gets text between two delimiters
 */
char* textBetween(char* thisText, char* startText, char* endText, char* returnText)
{
	//printf("textBetween\n");

    char* startPointer = NULL;
    int stringLength = 0;

    char* endPointer = NULL;
    int endLength = 0;

	if (strstr(startText, "start") != NULL)
	{
		// Set the beginning of the string
		startPointer = thisText;
	} else {
		startPointer = strstr(thisText, startText);

    	if (startPointer != NULL)
	    {
        	startPointer = startPointer + strlen(startText);
        }
	} // end if the start delimiter is "start"

    if (startPointer != NULL)
    {

		if (strstr(endText, "end") != NULL)
		{
			// Set the end of the string
			endPointer = thisText;
			endLength = 0;
		} else {
			endPointer = strstr(startPointer, endText);
			endLength = (int)strlen(endPointer);
		} // end if the end delimiter is "end"

        stringLength = strlen(startPointer) - endLength;

        if (stringLength == 0)
        {
		    returnText = "";
		    startPointer = NULL;
        } else {
	        // Copy characters between the start and end delimiters
    	    strncpy(returnText,startPointer, stringLength);
	        returnText[stringLength++] = '\0';
		}

    } else {
	    //printf("Start pointer not found\n");
	    returnText = "";
	
    } // end if the start pointer is not found

    return startPointer;
} // end textBetween method
