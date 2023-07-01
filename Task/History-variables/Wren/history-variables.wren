class HistoryVariable {
    construct new(initValue) {
        _history = [initValue]
    }

    currentValue { _history[-1] }
    currentValue=(newValue) { _history.add(newValue) }

    showHistory() {
        System.print("The variable's history, oldest values first, is:")
        for (item in _history) System.print(item)
    }
}

var v = HistoryVariable.new(1)
v.currentValue = 2
v.currentValue = 3
v.showHistory()
System.print("\nCurrent value is %(v.currentValue)")
