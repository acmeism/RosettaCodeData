shared test void searchAListTask() {
    value haystack = [
            "Zig", "Zag", "Wally", "Ronald", "Bush",
            "Krusty", "Charlie", "Bush", "Bozo"];

    assert(exists firstIdx = haystack.firstOccurrence("Bush"));
    assert(exists lastIdx = haystack.lastOccurrence("Bush"));

    assertEquals(firstIdx, 4);
    assertEquals(lastIdx, 7);
}
