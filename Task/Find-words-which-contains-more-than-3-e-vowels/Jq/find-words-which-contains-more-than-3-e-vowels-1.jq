inputs
| select(test("[aiou]")|not)
| select(test("e.*e.*e.*e"))
