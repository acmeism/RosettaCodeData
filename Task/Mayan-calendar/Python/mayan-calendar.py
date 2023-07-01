import datetime


def g2m(date, gtm_correlation=True):
    """
    Translates Gregorian date into Mayan date, see
    https://rosettacode.org/wiki/Mayan_calendar

    Input arguments:

     date: string date in ISO-8601 format: YYYY-MM-DD
     gtm_correlation: GTM correlation to apply if True, Astronomical correlation otherwise (optional, True by default)

    Output arguments:

     long_date: Mayan date in Long Count system as string
     round_date: Mayan date in Calendar Round system as string
    """

    # define some parameters and names

    correlation = 584283 if gtm_correlation else 584285

    long_count_days = [144000, 7200, 360, 20, 1]

    tzolkin_months = ['Imix’', 'Ik’', 'Ak’bal', 'K’an', 'Chikchan', 'Kimi', 'Manik’', 'Lamat', 'Muluk', 'Ok', 'Chuwen',
                      'Eb', 'Ben', 'Hix', 'Men', 'K’ib’', 'Kaban', 'Etz’nab’', 'Kawak', 'Ajaw']  # tzolk'in

    haad_months = ['Pop', 'Wo’', 'Sip', 'Sotz’', 'Sek', 'Xul', 'Yaxk’in', 'Mol', 'Ch’en', 'Yax', 'Sak’', 'Keh', 'Mak',
                   'K’ank’in', 'Muwan', 'Pax', 'K’ayab', 'Kumk’u', 'Wayeb’']  # haab'

    gregorian_days = datetime.datetime.strptime(date, '%Y-%m-%d').toordinal()
    julian_days = gregorian_days + 1721425

    # 1. calculate long count date

    long_date = list()
    remainder = julian_days - correlation

    for days in long_count_days:

        result, remainder = divmod(remainder, days)
        long_date.append(int(result))

    long_date = '.'.join(['{:02d}'.format(d) for d in long_date])

    # 2. calculate round calendar date

    tzolkin_month = (julian_days + 16) % 20
    tzolkin_day = ((julian_days + 5) % 13) + 1

    haab_month = int(((julian_days + 65) % 365) / 20)
    haab_day = ((julian_days + 65) % 365) % 20
    haab_day = haab_day if haab_day else 'Chum'

    lord_number = (julian_days - correlation) % 9
    lord_number = lord_number if lord_number else 9

    round_date = f'{tzolkin_day} {tzolkin_months[tzolkin_month]} {haab_day} {haad_months[haab_month]} G{lord_number}'

    return long_date, round_date

if __name__ == '__main__':

    dates = ['2004-06-19', '2012-12-18', '2012-12-21', '2019-01-19', '2019-03-27', '2020-02-29', '2020-03-01']

    for date in dates:

        long, round = g2m(date)
        print(date, long, round)
