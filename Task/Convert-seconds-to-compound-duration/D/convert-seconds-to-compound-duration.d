import std.stdio, std.conv, std.algorithm;

immutable uint SECSPERWEEK = 604_800;
immutable uint SECSPERDAY = 86_400;
immutable uint SECSPERHOUR = 3_600;
immutable uint SECSPERMIN = 60;

string ConvertSeconds(in uint seconds)
{
    uint rem = seconds;

    uint weeks = rem / SECSPERWEEK;
    rem %= SECSPERWEEK;
    uint days = rem / SECSPERDAY;
    rem %= SECSPERDAY;
    uint hours = rem / SECSPERHOUR;
    rem %= SECSPERHOUR;
    uint mins = rem / SECSPERMIN;
    rem %= SECSPERMIN;

    string formatted = "";

    (weeks != 0) ? formatted ~= (weeks.to!string ~ " wk, ") : formatted;
    (days != 0) ? formatted ~= (days.to!string ~ " d, ") : formatted;
    (hours != 0) ? formatted ~= (hours.to!string ~ " hr, ") : formatted;
    (mins != 0) ? formatted ~= (mins.to!string ~ " min, ") : formatted;
    (rem != 0) ? formatted ~= (rem.to!string ~ " sec") : formatted;

    if (formatted.endsWith(", ")) return formatted[0..$-2];

    return formatted;
}

void main()
{
    7_259.ConvertSeconds.writeln;
    86_400.ConvertSeconds.writeln;
    6_000_000.ConvertSeconds.writeln;
}
