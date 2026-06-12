public class textBetween
{
    /*
     * textBetween: Get the text between two delimiters
     */
    static String textBetween(String thisText, String startString, String endString)
    {
    	String returnText = "";
    	int startIndex = 0;
    	int endIndex = 0;
    	
    	if (startString.equals("start"))
    	{
    		startIndex = 0;
    	} else {
	    	startIndex = thisText.indexOf(startString);
	    	
	    	if (startIndex < 0)
	        {
	        	return "";	        	
	        } else {
	        	startIndex = startIndex + startString.length();
	        }
    	}

    	if (endString.equals("end"))
    	{
    		endIndex = thisText.length();
    	} else {
    		endIndex = thisText.indexOf(endString);

            if (endIndex <= 0)
            {
            	return "";
            } else {

            }	
    	}
    	
    	returnText = thisText.substring(startIndex,endIndex);
    	
    	return returnText;
    } // end method textBetween

    /**
     * Main method
     */
    public static void main(String[] args)
    {
    	String thisText = args[0];
    	String startDelimiter = args[1];
    	String endDelimiter = args[2];
    	
    	String returnText = "";
    	returnText = textBetween(thisText, startDelimiter, endDelimiter);
    	
        System.out.println(returnText);

    } // end method main

} // end class TextBetween
