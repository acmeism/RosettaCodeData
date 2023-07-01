def is_isbn13(n):
    n = n.replace('-','').replace(' ', '')
    if len(n) != 13:
        return False
    product = (sum(int(ch) for ch in n[::2])
               + sum(int(ch) * 3 for ch in n[1::2]))
    return product % 10 == 0

if __name__ == '__main__':
    tests = '''
978-1734314502
978-1734314509
978-1788399081
978-1788399083'''.strip().split()
    for t in tests:
        print(f"ISBN13 {t} validates {is_isbn13(t)}")
