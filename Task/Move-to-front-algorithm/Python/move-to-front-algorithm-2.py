def m2f_e(s, st):
    return [[st.index(ch), st.insert(0, st.pop(st.index(ch)))][0] for ch in s]

def m2f_d(sq, st):
    return ''.join([st[i], st.insert(0, st.pop(i))][0] for i in sq)

ST = list('abcdefghijklmnopqrstuvwxyz')
for s in ['broood', 'bananaaa', 'hiphophiphop']:
    encode = m2f_e(s, ST[::])
    print('%14r encodes to %r' % (s, encode), end=', ')
    decode = m2f_d(encode, ST[::])
    print('decodes back to %r' % decode)
    assert s == decode, 'Whoops!'
