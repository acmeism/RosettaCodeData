# Retrieve the first "item" element
doc.evaluate('//item', doc, {}, 7, {}).snapshotItem 0

# Perform an action on each "price" element (print it out)
prices = doc.evaluate "//price", doc, {}, 7, {}
for i in [0...prices.snapshotLength] by 1
    console.log prices.snapshotItem(i).textContent

# Get an array of all the "name" elements
names = doc.evaluate "//name", doc, {}, 7, {}
names = for i in [0...names.snapshotLength] by 1
    names.snapshotItem i
