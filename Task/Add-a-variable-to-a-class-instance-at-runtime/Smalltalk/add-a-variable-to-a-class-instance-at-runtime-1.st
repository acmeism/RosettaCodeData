|addSlot p|

addSlot :=
  [:obj :slotName |
    |anonCls newObj|
    anonCls := obj class
            subclass:(obj class name,'+') asSymbol
            instanceVariableNames:slotName
            classVariableNames:''
            poolDictionaries:'' category:nil
            inEnvironment:nil.
    anonCls compile:('%1 ^  %1' bindWith:slotName).
    anonCls compile:('%1:v %1 := v' bindWith:slotName).
    newObj := anonCls cloneFrom:obj.
    obj become:newObj.
  ].
