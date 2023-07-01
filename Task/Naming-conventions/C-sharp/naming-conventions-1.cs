public enum Planet {
    Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

[Flags]
public enum Days {
    None = 0,
    Sunday = 1,
    Monday = 2,
    Tuesday = 4,
    Wednesday = 8,
    Thursday = 16,
    Friday = 32,
    Saturday = 64,
    Workdays = Monday | Tuesday | Wednesday | Thursday | Friday
    AllWeek = Sunday | Saturday | Workdays
}
