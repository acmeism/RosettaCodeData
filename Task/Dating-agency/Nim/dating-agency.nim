const
  Sailors = ["Adrian", "Caspian", "Dune", "Finn", "Fisher",
             "Heron", "Kai", "Ray", "Sailor", "Tao"]
  Ladies = ["Ariel", "Bertha", "Blue", "Cali", "Catalina",
            "Gale", "Hannah", "Isla", "Marina", "Shelly"]

proc isNice(girl: string): bool =
  ord(girl[0]) mod 2 == 0

proc isLovableFor(girl, sailor: string): bool =
  ord(girl[^1]) mod 2 == ord(sailor[^1]) mod 2

for lady in Ladies:
  if lady.isNice():
    echo "Dating service should offer a date with ", lady
    for sailor in Sailors:
      if lady.isLovableFor(sailor):
        echo "    Sailor ", sailor, " should take an offer to date her."
  else:
    echo "Dating service should NOT offer a date with ", lady
