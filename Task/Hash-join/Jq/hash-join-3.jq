$ jq -c -r -n -f HashJoin.jq

{"age":27,"name":"Jonah","nemesis":"Whales"}
{"age":27,"name":"Jonah","nemesis":"Spiders"}
{"age":28,"name":"Alan","nemesis":"Ghosts"}
{"age":28,"name":"Alan","nemesis":"Zombies"}
{"age":28,"name":"Glory","nemesis":"Buffy"}

[27,"Jonah","Jonah","Whales"]
[27,"Jonah","Jonah","Spiders"]
[28,"Alan","Alan","Ghosts"]
[28,"Alan","Alan","Zombies"]
[28,"Glory","Glory","Buffy"]
