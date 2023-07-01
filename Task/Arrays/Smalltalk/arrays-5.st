array do:[:each | each printOn: aStream ]
array collect:[:each | each squared|
array select:[:each | each > 10]
