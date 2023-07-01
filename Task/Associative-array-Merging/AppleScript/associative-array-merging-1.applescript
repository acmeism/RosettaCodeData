set baseRecord to {|name|:"Rocket Skates", price:12.75, |color|:"yellow"}
set updateRecord to {price:15.25, |color|:"red", |year|:1974}

set mergedRecord to updateRecord & baseRecord
return mergedRecord
