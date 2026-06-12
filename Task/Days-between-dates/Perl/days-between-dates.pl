use feature 'say';
use Date::Calc qw(Delta_Days);

say Delta_Days(2018,7,13, 2019,9,13);   # triskaidekaphobia
say Delta_Days(1900,1,1,  2000,1,1);    # a century
say Delta_Days(2000,1,1,  2100,1,1);    # another, with one extra leap day
say Delta_Days(2020,1,1,  2019,10,1);   # backwards in time
say Delta_Days(2019,2,29, 2019,3,1);    # croaks
