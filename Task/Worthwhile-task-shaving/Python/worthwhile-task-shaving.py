row_names = [
    " 1 Second",
    " 5 Seconds",
    "30 Seconds",
    " 1 Minute",
    " 5 Minutes",
    "30 Minutes",
    " 1 Hour",
    " 6 Hours",
    " 1 Day",
]

row_values_in_seconds = [1, 5, 30, 60, 300, 1800, 3600, 21600, 86400]
days_in_a_year = 365.25

seconds_in_minute = 60
seconds_in_hour = seconds_in_minute * 60
seconds_in_day = seconds_in_hour * 24
seconds_in_week = seconds_in_day * 7
seconds_in_year = seconds_in_day * days_in_a_year
seconds_in_month = seconds_in_year / 12

column_names = [
    "Shaved-off |",
    " 50/Day",
    " 5/Day",
    " Daily",
    " Weekly",
    " Monthly",
    " Yearly",
]

# column values
shaves_per_year = [
    50 * days_in_a_year,
    5 * days_in_a_year,
    days_in_a_year,
    days_in_a_year / 7,
    12,
    1,
]


def get_shave_string(amount_of_interval_in, interval_in) -> str:
    plural_string = ""
    if int(amount_of_interval_in) > 1:
        plural_string = "s"

    result = f"{int(amount_of_interval_in)} {interval_in}{plural_string}"
    padded_result = result.ljust(3).rjust(15)

    return padded_result


if __name__ == "__main__":
    print(" " * 34, "How Often You Do the Task\n")

    for column_name in column_names:
        print(str(column_name).rjust(14), end=" ")
    print()
    print("-" * 104)

    for row_number, row_name in enumerate(row_names):
        row = f"{row_name} |".rjust(14)

        for column_value in range(6):
            t = shaves_per_year[column_value] * row_values_in_seconds[row_number] * 5
            if t < seconds_in_minute:
                amount_of_interval, interval = t, "Second"
            elif t < seconds_in_hour:
                amount_of_interval, interval = t / seconds_in_minute, "Minute"
            elif t < seconds_in_day:
                amount_of_interval, interval = t / seconds_in_hour, "Hour"
            elif t < seconds_in_week * 2:
                amount_of_interval, interval = t / seconds_in_day, "Day"
            elif t < seconds_in_month * 2:
                amount_of_interval, interval = t / seconds_in_week, "Week"
            elif t < seconds_in_year:
                amount_of_interval, interval = t / seconds_in_month, "Month"
            else:
                row += "n/a".ljust(3).rjust(15)
                continue
            row += get_shave_string(amount_of_interval, interval)
        print(row)
