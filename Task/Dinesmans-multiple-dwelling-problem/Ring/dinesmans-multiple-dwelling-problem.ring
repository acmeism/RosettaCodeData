floor1 = "return baker!=cooper and baker!=fletcher and baker!=miller and
          baker!=smith and cooper!=fletcher and cooper!=miller and
          cooper!=smith and fletcher!=miller and fletcher!=smith and
          miller!=smith"
floor2 = "return baker!=4"
floor3 = "return cooper!=0"
floor4 = "return fletcher!=0 and fletcher!=4"
floor5 = "return miller>cooper"
floor6 = "return fabs(smith-fletcher)!=1"
floor7 = "return fabs(fletcher-cooper)!=1"
for baker = 0 to 4
    for cooper = 0 to 4
        for fletcher = 0 to 4
            for miller = 0 to 4
                for smith = 0 to 4
                    if eval(floor2) if eval(floor3) if eval(floor5)
                       if eval(floor4) if eval(floor6) if eval(floor7)
                          if eval(floor1)
                             see "baker lives on floor " + baker + nl
                             see "cooper lives on floor " + cooper + nl
                             see "fletcher lives on floor " + fletcher + nl
                             see "miller lives on floor " + miller + nl
                             see "smith lives on floor " + smith + nl ok ok ok ok ok ok ok
                next
            next
        next
    next
next
