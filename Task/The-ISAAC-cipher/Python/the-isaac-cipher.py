import random
import collections

INT_MASK = 0xFFFFFFFF       # we use this to emulate 32-bit overflow semantics by masking off higher bits after operations

class IsaacRandom(random.Random):
    """
    Random number generator using the ISAAC algorithm.
    """

    def seed(self, seed=None):
        """
        Initialize internal state.

        The seed, if given, can be a string, an integer, or an iterable that contains
        integers only. If no seed is given, a fixed default state is set up; unlike
        our superclass, this class will not attempt to randomize the seed from outside sources.
        """
        def mix():
            init_state[0] ^= ((init_state[1]<<11)&INT_MASK); init_state[3] += init_state[0]; init_state[3] &= INT_MASK; init_state[1] += init_state[2]; init_state[1] &= INT_MASK
            init_state[1] ^=  (init_state[2]>>2)           ; init_state[4] += init_state[1]; init_state[4] &= INT_MASK; init_state[2] += init_state[3]; init_state[2] &= INT_MASK
            init_state[2] ^= ((init_state[3]<<8 )&INT_MASK); init_state[5] += init_state[2]; init_state[5] &= INT_MASK; init_state[3] += init_state[4]; init_state[3] &= INT_MASK
            init_state[3] ^=  (init_state[4]>>16)          ; init_state[6] += init_state[3]; init_state[6] &= INT_MASK; init_state[4] += init_state[5]; init_state[4] &= INT_MASK
            init_state[4] ^= ((init_state[5]<<10)&INT_MASK); init_state[7] += init_state[4]; init_state[7] &= INT_MASK; init_state[5] += init_state[6]; init_state[5] &= INT_MASK
            init_state[5] ^=  (init_state[6]>>4 )          ; init_state[0] += init_state[5]; init_state[0] &= INT_MASK; init_state[6] += init_state[7]; init_state[6] &= INT_MASK
            init_state[6] ^= ((init_state[7]<<8 )&INT_MASK); init_state[1] += init_state[6]; init_state[1] &= INT_MASK; init_state[7] += init_state[0]; init_state[7] &= INT_MASK
            init_state[7] ^=  (init_state[0]>>9 )          ; init_state[2] += init_state[7]; init_state[2] &= INT_MASK; init_state[0] += init_state[1]; init_state[0] &= INT_MASK

        super().seed(0) # give a chance for the superclass to reset its state - the actual seed given to it doesn't matter
        if seed is not None:
            if isinstance(seed, str):
                seed = [ord(x) for x in seed]
            elif isinstance(seed, collections.Iterable):
                seed = [x & INT_MASK for x in seed]
            elif isinstance(seed, int):
                val = abs(seed)
                seed = []
                while val:
                    seed.append(val & INT_MASK)
                    val >>= 32
            else:
                raise TypeError('Seed must be string, integer or iterable of integer')

            # make sure the seed list is exactly 256 elements long
            if len(seed)>256:
                del seed[256:]
            elif len(seed)<256:
                seed.extend([0]*(256-len(seed)))

        self.aa = self.bb = self.cc = 0
        self.mm = []
        init_state = [0x9e3779b9]*8

        for _ in range(4):
            mix()

        for i in range(0, 256, 8):
            if seed is not None:
                for j in range(8):
                    init_state[j] += seed[i+j]
                    init_state[j] &= INT_MASK
            mix()
            self.mm += init_state

        if seed is not None:
            for i in range(0, 256, 8):
                for j in range(8):
                    init_state[j] += self.mm[i+j]
                    init_state[j] &= INT_MASK
                mix()
                for j in range(8):
                    self.mm[i+j] = init_state[j]

        self.rand_count = 256
        self.rand_result = [0]*256

    def getstate(self):
        return super().getstate(), self.aa, self.bb, self.cc, self.mm, self.rand_count, self.rand_result

    def setstate(self, state):
        super().setstate(state[0])
        _, self.aa, self.bb, self.cc, self.mm, self.rand_count, self.rand_result = state

    def _generate(self):
        # Generate 256 random 32-bit values and save them in an internal field.
        # The actual random functions will dish out these values to callers.
        self.cc = (self.cc + 1) & INT_MASK
        self.bb = (self.bb + self.cc) & INT_MASK

        for i in range(256):
            x = self.mm[i]
            mod = i & 3
            if mod==0:
                self.aa ^= ((self.aa << 13) & INT_MASK)
            elif mod==1:
                self.aa ^= (self.aa >> 6)
            elif mod==2:
                self.aa ^= ((self.aa << 2) & INT_MASK)
            else: # mod == 3
                self.aa ^= (self.aa >> 16)
            self.aa = (self.mm[i^128] + self.aa) & INT_MASK
            y = self.mm[i] = (self.mm[(x>>2) & 0xFF] + self.aa + self.bb) & INT_MASK
            self.rand_result[i] = self.bb = (self.mm[(y>>10) & 0xFF] + x) & INT_MASK

        self.rand_count = 0

    def next_int(self):
        """Return a random integer between 0 (inclusive) and 2**32 (exclusive)."""
        if self.rand_count == 256:
            self._generate()
        result = self.rand_result[self.rand_count]
        self.rand_count += 1
        return result

    def getrandbits(self, k):
        """Return a random integer between 0 (inclusive) and 2**k (exclusive)."""
        result = 0
        ints_needed = (k+31)//32
        ints_used = 0
        while ints_used < ints_needed:
            if self.rand_count == 256:
                self._generate()
            ints_to_take = min(256-self.rand_count, ints_needed)
            for val in self.rand_result[self.rand_count : self.rand_count+ints_to_take]:
                result = (result << 32) | val
            self.rand_count += ints_to_take
            ints_used += ints_to_take
        result &= ((1<<k)-1)    # mask off extra bits, if any
        return result

    def random(self):
        """Return a random float between 0 (inclusive) and 1 (exclusive)."""
        # A double stores 53 significant bits, so scale a 53-bit integer into the [0..1) range.
        return self.getrandbits(53) * (2**-53)

    def rand_char(self):
        """Return a random integer from the printable ASCII range [32..126]."""
        return self.next_int() % 95 + 32

    def vernam(self, msg):
        """
        Encrypt/decrypt the given bytes object with the XOR algorithm, using the current generator state.

        To decrypt an encrypted string, restore the state of the generator to the state it had
        during encryption, then call this method with the encrypted string.
        """
        return bytes((self.rand_char() & 0xFF) ^ x for x in msg)

    # Constants for selecting Caesar operation modes.
    ENCIPHER = 'encipher'
    DECIPHER = 'decipher'

    @staticmethod
    def _caesar(ciphermode, ch, shift, modulo, start):
        if ciphermode == IsaacRandom.DECIPHER:
            shift = -shift
        n = ((ch-start)+shift) % modulo
        if n<0:
            n += modulo
        return start+n

    def caesar(self, ciphermode, msg, modulo, start):
        """
        Encrypt/decrypt a string using the Caesar algorithm.

        For decryption to work, the generator must be in the same state it was during encryption,
        and the same modulo and start parameters must be used.

        ciphermode must be one of IsaacRandom.ENCIPHER or IsaacRandom.DECIPHER.
        """
        return bytes(self._caesar(ciphermode, ch, self.rand_char(), modulo, start) for ch in msg)

if __name__=='__main__':
    import binascii

    def hexify(b):
        return binascii.hexlify(b).decode('ascii').upper()

    MOD = 95
    START = 32

    msg = 'a Top Secret secret'
    key = 'this is my secret key'
    isaac_random = IsaacRandom(key)
    vernam_encoded = isaac_random.vernam(msg.encode('ascii'))
    caesar_encoded = isaac_random.caesar(IsaacRandom.ENCIPHER, msg.encode('ascii'), MOD, START)
    isaac_random.seed(key)
    vernam_decoded = isaac_random.vernam(vernam_encoded).decode('ascii')
    caesar_decoded = isaac_random.caesar(IsaacRandom.DECIPHER, caesar_encoded, MOD, START).decode('ascii')

    print('Message:', msg)
    print('Key    :', key)
    print('XOR    :', hexify(vernam_encoded))
    print('XOR dcr:', vernam_decoded)
    print('MOD    :', hexify(caesar_encoded))
    print('MOD dcr:', caesar_decoded)
