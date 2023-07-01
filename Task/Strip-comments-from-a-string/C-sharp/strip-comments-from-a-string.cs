using System.Text.RegularExpressions;

string RemoveComments(string str, string delimiter)
        {
            //regular expression to find a character (delimiter) and
            //      replace it and everything following it with an empty string.
            //.Trim() will remove all beginning and ending white space.
            return Regex.Replace(str, delimiter + ".+", string.Empty).Trim();
        }
