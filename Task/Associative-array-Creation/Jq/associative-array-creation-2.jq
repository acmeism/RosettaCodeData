def collisionless:
   if type == "object" then with_entries(.value = (.value|collisionless))|tostring
   elif type == "array" then map(collisionless)|tostring
   else (type[0:1] + tostring)
   end;

# WARNING: addKey(key;value) will erase any previous value associated with key
def addKey(key;value):
  if type == "object" then  . + { (key|collisionless): value }
  else {} | addKey(key;value)
  end;

def getKey(key): .[key|collisionless];

def removeKey(key): delpaths( [ [key|collisionless] ] );
