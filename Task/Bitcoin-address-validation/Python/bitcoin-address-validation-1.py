from hashlib import sha256

digits58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def decode_base58(bc, length):
    n = 0
    for char in bc:
        n = n * 58 + digits58.index(char)
    return n.to_bytes(length, 'big')
def check_bc(bc):
    try:
        bcbytes = decode_base58(bc, 25)
        return bcbytes[-4:] == sha256(sha256(bcbytes[:-4]).digest()).digest()[:4]
    except Exception:
        return False

print(check_bc('1AGNa15ZQXAZUgFiqJ3i7Z2DPU2J6hW62i'))
print(check_bc("17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j"))
