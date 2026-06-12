import random

#%%Sample price generation
price_list_size = random.choice(range(99_000, 101_000))
price_list = random.choices(range(100_000), k=price_list_size)

delta_price = 1     # Minimum difference between any two different prices.

#%% API
def get_prange_count(startp, endp):
    return len([r for r in price_list if startp <= r <= endp])

def get_max_price():
    return max(price_list)

#%% Solution
def get_5k(mn=0, mx=get_max_price(), num=5_000):
    "Binary search for num items between mn and mx, adjusting mx"
    count = get_prange_count(mn, mx)
    delta_mx = (mx - mn) / 2
    while count != num and delta_mx >= delta_price / 2:
        mx += -delta_mx if count > num else +delta_mx
        mx = mx // 1    # Floor
        count, delta_mx = get_prange_count(mn, mx), delta_mx / 2
    return mx, count

def get_all_5k(mn=0, mx=get_max_price(), num=5_000):
    "Get all non-overlapping ranges"
    partmax, partcount = get_5k(mn, mx, num)
    result = [(mn, partmax, partcount)]
    while partmax < mx:
        partmin = partmax + delta_price
        partmax, partcount = get_5k(partmin, mx, num)
        assert partcount > 0, \
            f"price_list from {partmin} with too many of the same price"
        result.append((partmin, partmax, partcount))
    return result

if __name__ == '__main__':
    print(f"Using {price_list_size} random prices from 0 to {get_max_price()}")
    result = get_all_5k()
    print(f"Splits into {len(result)} bins of approx 5000 elements")
    for mn, mx, count in result:
        print(f"  From {mn:8.1f} ... {mx:8.1f} with {count} items.")

    if len(price_list) != sum(count for mn, mx, count in result):
        print("\nWhoops! Some items missing:")
