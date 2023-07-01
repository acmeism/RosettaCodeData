using System;

public static string RemoveCharactersFromString(string testString, string removeChars)
{
    char[] charAry = removeChars.ToCharArray();
    string returnString = testString;
    foreach (char c in charAry)
    {
        while (returnString.IndexOf(c) > -1)
        {
            returnString = returnString.Remove(returnString.IndexOf(c), 1);
        }
    }
    return returnString;
}
