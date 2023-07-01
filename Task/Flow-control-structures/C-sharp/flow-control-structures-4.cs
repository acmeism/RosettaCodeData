async Task DoStuffAsync() {
    DoSomething();
    await someOtherTask;//returns control to caller if someOtherTask is not yet finished.
    DoSomethingElse();
}
