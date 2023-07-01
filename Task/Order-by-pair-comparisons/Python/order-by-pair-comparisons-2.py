from functools import cmp_to_key

def user_cmp(a, b):
    return int(input(f"IS {a:>6} <, ==, or > {b:>6}  answer -1, 0 or 1:"))

if __name__ == '__main__':
    items = 'violet red green indigo blue yellow orange'.split()
    ans = sorted(items, key=cmp_to_key(user_cmp))
    print('\n' + ' '.join(ans))
