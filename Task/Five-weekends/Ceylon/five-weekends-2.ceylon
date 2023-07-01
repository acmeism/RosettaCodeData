import ceylon.time {
    date,
    Date
}
import ceylon.time.base {
    january,
    december,
    friday,
    Month
}

shared void run() {
    [Date[],Integer[]] result = fiveWeekendsRecursive();

    value fiveWeekendFirstOfMonths = result[0];
    Integer[] yearsWithNoFiveWeekendMonths = result[1];

    print("# five weekend months = ``fiveWeekendFirstOfMonths.size``");
    print("# years without five weekend months = ``yearsWithNoFiveWeekendMonths.size``");
    yearsWithNoFiveWeekendMonths.each(print);
}

[Date[], Integer[]] fiveWeekendsRecursive()
    => fiveWeekendsRecursiveInner{ year = 1900;
                                   month = january;
                                   fiveWeekendFirstOfMonths = [];
                                   yearsWithNoFiveWeekendMonths = []; };

[Date[], Integer[]] fiveWeekendsRecursiveInner(Integer year,
                                               Month month,
                                               Date[] fiveWeekendFirstOfMonths,
                                               Integer[] yearsWithNoFiveWeekendMonths) {
    if (year > 2100) {
        return [fiveWeekendFirstOfMonths,yearsWithNoFiveWeekendMonths];
    }

    Date firstOfMonth = date{ year = year; month = month; day = 1; };

    Boolean isFiveWeekendMonth =
         (month.numberOfDays() == 31 && friday == firstOfMonth.dayOfWeek);

    Boolean hasNoFiveWeekends =
        month == december &&
        ! isFiveWeekendMonth &&
        fiveWeekendFirstOfMonths.filter((date) => date.year == year).size == 0;

    return fiveWeekendsRecursiveInner(if (month == december) then year+1 else year,
                                      if (month == december) then january else month.plusMonths(1),
                                      if (isFiveWeekendMonth)
                                        then fiveWeekendFirstOfMonths.withTrailing(firstOfMonth)
                                        else fiveWeekendFirstOfMonths,
                                      if (hasNoFiveWeekends)
                                        then yearsWithNoFiveWeekendMonths.withTrailing(year)
                                        else yearsWithNoFiveWeekendMonths);
}
