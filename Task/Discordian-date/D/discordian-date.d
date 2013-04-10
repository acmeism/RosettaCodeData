import std.stdio, std.datetime, std.conv, std.string;

immutable seasons = ["Chaos", "Discord", "Confusion", "Bureaucracy",
                     "The Aftermath"];

immutable weekday = ["Sweetmorn", "Boomtime", "Pungenday",
                     "Prickle-Prickle", "Setting Orange"];

immutable apostle = ["Mungday", "Mojoday", "Syaday", "Zaraday",
                     "Maladay"];

immutable holiday = ["Chaoflux", "Discoflux", "Confuflux",
                     "Bureflux", "Afflux"];

string discordianDate(in Date date) {
    auto dyear = text(date.year + 1166);

    auto isLeapYear = date.isLeapYear;
    if (isLeapYear && date.month == 2 && date.day == 29)
        return "St. Tib's Day, in the YOLD " ~ dyear;

    auto doy = date.dayOfYear;
    if (isLeapYear && doy >= 60)
        doy--;

    auto dsday = doy % 73; // season day
    if (dsday == 5)  return apostle[doy / 73] ~ ", in the YOLD " ~ dyear;
    if (dsday == 50) return holiday[doy / 73] ~ ", in the YOLD " ~ dyear;

    auto dseas = seasons[doy / 73];
    auto dwday = weekday[(doy-1) % 5];

    return format("%s, day %s of %s in the YOLD %s", dwday, dsday, dseas,
            dyear);
}

void main() {
    auto today = cast(Date)Clock.currTime();
    writeln(discordianDate(today));
}

unittest {
    assert(discordianDate(Date(2010,7,22)) ==
           "Pungenday, day 57 of Confusion in the YOLD 3176");
    assert(discordianDate(Date(2012,2,28)) ==
           "Prickle-Prickle, day 59 of Chaos in the YOLD 3178");
    assert(discordianDate(Date(2012,2,29)) ==
           "St. Tib's Day, in the YOLD 3178");
    assert(discordianDate(Date(2012,3, 1)) ==
           "Setting Orange, day 60 of Chaos in the YOLD 3178");
    assert(discordianDate(Date(2010,1, 5)) ==
           "Mungday, in the YOLD 3176");
    assert(discordianDate(Date(2011,5, 3)) ==
           "Discoflux, in the YOLD 3177");
}
