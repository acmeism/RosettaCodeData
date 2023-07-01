def tobits(n, _group=8, _sep='_', _pad=False):
    'Express n as binary bits with separator'
    bits = '{0:b}'.format(n)[::-1]
    if _pad:
        bits = '{0:0{1}b}'.format(n,
                                  ((_group+len(bits)-1)//_group)*_group)[::-1]
        answer = _sep.join(bits[i:i+_group]
                                 for i in range(0, len(bits), _group))[::-1]
        answer = '0'*(len(_sep)-1) + answer
    else:
        answer = _sep.join(bits[i:i+_group]
                           for i in range(0, len(bits), _group))[::-1]
    return answer

def tovlq(n):
    return tobits(n, _group=7, _sep='1_', _pad=True)

def toint(vlq):
    return int(''.join(vlq.split('_1')), 2)

def vlqsend(vlq):
    for i, byte in enumerate(vlq.split('_')[::-1]):
        print('Sent byte {0:3}: {1:#04x}'.format(i, int(byte,2)))
