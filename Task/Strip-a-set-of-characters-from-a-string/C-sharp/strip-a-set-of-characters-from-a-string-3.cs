using System;
using System.Text.RegularExpressions;

private static string RegexRemoveCharactersFromString(string testString, string removeChars)
{
    string pattern = "[" + removeChars + "]";
    return Regex.Replace(testString, pattern, "");
}
