t = .table~new        -- a table example to demonstrate the difference
t['abc'] = 1          -- sets an item at index 'abc'
t['abc'] = 2          -- updates that item
say t~items t['abc']  -- displays "1 2"
r = .relation~new
r['abc'] = 1          -- sets an item at index 'abc'
r['abc'] = 2          -- adds an additional item at the same index
say r~items r['abc']  -- displays "2 2" this has two items in it now

do item over r~allAt('abc')   -- retrieves all items at the index 'abc'
  say item
end
