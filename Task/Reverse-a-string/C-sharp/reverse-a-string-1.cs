static string ReverseString(string input)
{
    char[] inputChars = input.ToCharArray();
    Array.Reverse(inputChars);
    return new string(inputChars);
}
