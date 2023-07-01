shared void run() {
    value knapsack = pack(items, empty(400));

    print(knapsack);
}

class Item(name,weight,theValue) {
    String name;
    shared Integer weight;
    shared Float theValue;

    shared actual String string = "item(``name``, ``weight``, ``theValue``)";
}

class Knapsack(items,theValue,weight,available) {
    shared Item[] items;
    shared Float theValue;
    shared Integer weight;
    shared Integer available;

    shared Boolean canAccept(Item item)
        => item.weight <= available;

    String itemsString = items.fold("")((total, remaining) => "``total``\t\n``remaining.string``" );

    shared actual String string = "Total value: ``theValue``\nTotal weight: ``weight``\nItems:\n``itemsString``";
}

Knapsack empty(Integer capacity)
    => Knapsack([], 0.0, 0, capacity);


Item[] items =
        [
         Item("map", 9, 150.0),
         Item("compass", 13, 35.0),
         Item("water", 153, 200.0),
         Item("sandwich", 50, 160.0),
         Item("glucose", 15, 60.0),
         Item("tin", 68, 45.0),
         Item("banana", 27, 60.0),
         Item("apple", 39, 40.0),
         Item("cheese", 23, 30.0),
         Item("beer", 52, 10.0),
         Item("cream", 11, 70.0),
         Item("camera", 32, 30.0),
         Item("tshirt", 24, 15.0),
         Item("trousers", 48, 10.0),
         Item("umbrella", 73, 40.0),
         Item("trousers", 42, 70.0),
         Item("overclothes", 43, 75.0),
         Item("notecase", 22, 80.0),
         Item("sunglasses", 7, 20.0),
         Item("towel", 18, 12.0),
         Item("socks", 4, 50.0),
         Item("book", 30, 10.0)
        ];


Knapsack add(Item item, Knapsack knapsack)
    => Knapsack { items = knapsack.items.withTrailing(item);
                  theValue = knapsack.theValue + item.theValue;
                  weight = knapsack.weight + item.weight;
                  available = knapsack.available - item.weight; };

Float rating(Item item) => item.theValue / item.weight.float;

Knapsack pack(Item[] items, Knapsack knapsack)
    // Sort the items by decreasing rating, that is, value divided by weight
    => let (itemsSorted =
                items.group(rating)
                     .sort(byDecreasing((Float->[Item+] entry) => entry.key))
                     .map(Entry.item)
                     .flatMap((element) => element)
                     .sequence())

    packRecursive(itemsSorted,knapsack);

Knapsack packRecursive(Item[] sortedItems, Knapsack knapsack)
    => if (exists firstItem=sortedItems.first, knapsack.canAccept(firstItem))
        then packRecursive(sortedItems.rest, add(firstItem,knapsack))
        else knapsack;
