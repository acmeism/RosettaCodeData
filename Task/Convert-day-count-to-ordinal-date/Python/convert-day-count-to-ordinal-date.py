def daycountToGregorian400(daycount: int) -> str:
    """
    Converts a non-negative day count (days since 0000-01-01 in the proleptic
    Gregorian calendar) into a Gregorian calendar date string in the format
    DD-MM-YYYY.

    This implementation leverages the 400-year Gregorian cycle, which always
    contains exactly 146,097 days (including leap years).
    """
    if daycount < 0:
        raise ValueError("daycount must be non-negative")

    def isLeap(y: int) -> bool:
        """
        Determines if a year `y` (within a 400-year cycle, 0–399) is a leap year.

        In the Gregorian calendar:

        * Every year divisible by 4 is a leap year,
        * Except end-of-century years, which must also be divisible by 400.

        Since this function is used only for years 0–399 in the cycle, year 0 is treated
        as divisible by 400 (i.e., a leap year).
        """
        return (y % 4 == 0) and ((y % 100) != 0 or (y % 400) == 0)

    CYCLE_DAYS = 146097              # Total number of days in a 400-year Gregorian cycle
    cycles = daycount // CYCLE_DAYS  # Determine how many full 400-year cycles fit into the daycount
    rem = daycount % CYCLE_DAYS      # Remaining days after removing full cycles

    # Precompute cumulative days at the start of each year in the 400-year cycle
    cumulative = [0] * 401  # cumulative[i] = total days from year 0 to year i-1
    for y in range(400):
        cumulative[y+1] = cumulative[y] + 365 + (1 if isLeap(y) else 0)

    # Binary search to find the year within the 400-year cycle that contains `rem`
    # days
    lo, hi = 0, 400
    while lo < hi:
        mid = (lo + hi) // 2
        # If the total days up to the *end* of year `mid` is <= rem, then the date is in a
        # later year
        if cumulative[mid+1] <= rem:
            lo = mid + 1
        else:
            hi = mid

    # `lo` is now the year index within the cycle (0 to 399)
    yearInCycle = lo
    # Compute the day of the year (0-based) within `yearInCycle`
    dayOfYear = rem - cumulative[yearInCycle]

    # Define month lengths for the found year, accounting for leap February
    monthLengths = [31, 29 if isLeap(yearInCycle) else 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    # Convert day-of-year to month and day (1-based)
    m = 1            # Start at January
    dom = dayOfYear  # Days remaining to assign to months
    for ml in monthLengths:
        if dom < ml:
            # Current month contains the target day
            day = dom + 1  # Convert to 1-based day
            month = m
            break
        dom -= ml  # Subtract days of this month
        m += 1     # Move to next month

    # Compute the actual calendar year (proleptic Gregorian)
    year = cycles * 400 + yearInCycle
    # Return formatted date string: DD-MM-YYYY
    return f"{day:02d}-{month:02d}-{year:04d}"

# Demonstration loop:
#
# For selected daycounts (representing base dates), print the date every 146097
# days (i.e., every full 400-year cycle)
for daycount in [0, 109573, 146096]:
    print(f"Daycount: {daycount}")
    for i in range(6):
        # Add `i` full cycles to the base daycount
        date = daycountToGregorian400(i*146097+daycount)
        print(date)
    print()
