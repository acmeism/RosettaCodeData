leapyear(year)
{
    if (Mod(year, 100) = 0)
        return (Mod(year, 400) = 0)
    return (Mod(year, 4) = 0)
}

MsgBox, % leapyear(1604)
