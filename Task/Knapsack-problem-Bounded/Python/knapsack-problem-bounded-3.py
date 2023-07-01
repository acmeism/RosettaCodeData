items = {
	"sandwich":	(50,	60,	2),
	"map": 		(9,	150,	1),
	"compass": 	(13,	35,	1),
	"water": 	(153,	200,	3),
	"glucose": 	(15,	60,	2),
	"tin": 		(68,	45,	3),
	"banana": 	(27,	60,	3),
	"apple": 	(39,	40,	3),
	"cheese": 	(23,	30,	1),
	"beer": 	(52,	10,	3),
	"suntan cream": (11,	70,	1),
	"camera": 	(32,	30,	1),
	"t-shirt": 	(24,	15,	2),
	"trousers": 	(48,	10,	2),
	"umbrella": 	(73,	40,	1),
	"w-trousers": 	(42,	70,	1),
	"w-overcoat": 	(43,	75,	1),
	"note-case": 	(22,	80,	1),
	"sunglasses": 	(7,	20,	1),
	"towel": 	(18,	12,	2),
	"socks": 	(4,	50,	1),
	"book": 	(30,	10,	2),
}

item_keys = list(items.keys())

#cache: could just use memoize module, but explicit caching is clearer
def choose_item(weight, idx, cache):
    if idx < 0: return 0, []

    k = (weight, idx)
    if k in cache: return cache[k]

    name, w, v, qty = item_keys[idx], *items[item_keys[idx]]
    best_v, best_list = 0, []

    for i in range(0, qty + 1):
        wlim = weight - i * w
        if wlim < 0: break

        val, taken = choose_item(wlim, idx - 1, cache)
        if val + i * v > best_v:
            best_v = val + i * v
            best_list = taken[:]
            best_list.append((i, name))

    cache[k] = [best_v, best_list]
    return best_v, best_list


v, lst = choose_item(400, len(items) - 1, {})
w = 0
for cnt, name in lst:
    if cnt > 0:
        print(cnt, name)
        w = w + items[name][0] * cnt

print("Total weight:", w, "Value:", v)
