import std.algorithm.iteration : filter, joiner, map;
import std.algorithm.searching : canFind;
import std.algorithm.sorting : sort;
import std.array : array;
import std.datetime.date : Date, Month;
import std.stdio : writeln;

void main() {
    auto choices = [
        // Month.jan
        Date(2019, Month.may, 15),
        Date(2019, Month.may, 16),
        Date(2019, Month.may, 19),  // unique day (1)

        Date(2019, Month.jun, 17),
        Date(2019, Month.jun, 18),  // unique day (1)

        Date(2019, Month.jul, 14),
        Date(2019, Month.jul, 16),  // final answer

        Date(2019, Month.aug, 14),
        Date(2019, Month.aug, 15),
        Date(2019, Month.aug, 17),
    ];

    // The month cannot have a unique day because Albert knows the month, and knows that Bernard does not know the answer
    auto uniqueMonths = choices.sort!"a.day < b.day".groupBy.filter!"a.array.length == 1".joiner.map!"a.month";
    // writeln(uniqueMonths.save);
    auto filter1 = choices.filter!(a => !canFind(uniqueMonths.save, a.month)).array;

    // Bernard now knows the answer, so the day must be unique within the remaining choices
    auto uniqueDays = filter1.sort!"a.day < b.day".groupBy.filter!"a.array.length == 1".joiner.map!"a.day";
    auto filter2 = filter1.filter!(a => canFind(uniqueDays.save, a.day)).array;

    // Albert knows the answer too, so the month must be unique within the remaining choices
    auto birthDay = filter2.sort!"a.month < b.month".groupBy.filter!"a.array.length == 1".joiner.front;

    // print the result
    writeln(birthDay.month, " ", birthDay.day);
}
