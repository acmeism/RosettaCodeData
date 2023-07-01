static int[] sedol_weights = { 1, 3, 1, 7, 3, 9 };
static int sedolChecksum(string sedol)
{
    int len = sedol.Length;
    int sum = 0;

    if (len == 7) //SEDOL code already checksummed?
        return (int)sedol[6];

    if ((len > 7) || (len < 6) || System.Text.RegularExpressions.Regex.IsMatch(sedol, "[AEIOUaeiou]+")) //invalid SEDOL
        return -1;

    for (int i = 0; i < 6; i++)
    {
        if (Char.IsDigit(sedol[i]))
            sum += (((int)sedol[i] - 48) * sedol_weights[i]);

        else if (Char.IsLetter(sedol[i]))
            sum += (((int)Char.ToUpper(sedol[i]) - 55) * sedol_weights[i]);

        else
            return -1;

    }

    return (10 - (sum % 10)) % 10;
}
