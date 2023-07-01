while (conditionA) {
    for (int i = 0; i < 10; i++) {
        if (conditionB) goto NextSection;
        DoSomething(i);
    }
}
NextSection: DoOtherStuff();
