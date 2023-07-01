switch (value)
    if (0)
        // Do thing if zero
        // DM does not have fall through of switch cases, so explicit break is not required.
    if (1, 2, 3)
        // Multiple values can be allowed by using commas

    if (10 to 20)
        // Ranges are also allowed.
        // Ranges include the bounds (10 and 20 here),
        // and are checked in order if there is potential for overlap.

    else
        // Fallback if nothing was matched.
