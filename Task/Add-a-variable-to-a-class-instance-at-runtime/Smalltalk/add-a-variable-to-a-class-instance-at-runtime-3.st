!Object methodsFor:'adding slots'!

addSlot: slotName
    |anonCls newObj|

    anonCls := self class
            subclass:(self class name,'+') asSymbol
            instanceVariableNames:slotName
            classVariableNames:''
            poolDictionaries:'' category:nil
            inEnvironment:nil.
    anonCls compile:('%1 ^  %1' bindWith:slotName).
    anonCls compile:('%1:v %1 := v' bindWith:slotName).
    newObj := anonCls cloneFrom:self.
    self become:newObj.
