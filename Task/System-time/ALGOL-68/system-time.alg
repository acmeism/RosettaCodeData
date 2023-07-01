FORMAT time repr = $"year="4d,", month="2d,", day="2d,", hours="2d,",  \
                   minutes="2d,", seconds="2d,", day of week="d,",  \
                   daylight-saving-time flag="dl$;
printf((time repr, local time));
printf((time repr, utc time))
