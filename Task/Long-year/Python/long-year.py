'''Long Year ?'''

from datetime import date


# longYear :: Year Int -> Bool
def longYear(y):
    '''True if the ISO year y has 53 weeks.'''
    return 52 < date(y, 12, 28).isocalendar()[1]


# --------------------------TEST---------------------------
# main :: IO ()
def main():
    '''Longer (53 week) years in the range 2000-2100'''
    for year in [
            x for x in range(2000, 1 + 2100)
            if longYear(x)
    ]:
        print(year)


# MAIN ---
if __name__ == '__main__':
    main()
