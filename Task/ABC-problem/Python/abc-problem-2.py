BLOCKS = 'BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM'.split()

def _abc(word, blocks):
    for i, ch in enumerate(word):
        for blk in (b for b in blocks if ch in b):
            whatsleft = word[i + 1:]
            blksleft = blocks[:]
            blksleft.remove(blk)
            if not whatsleft:
                return True, blksleft
            if not blksleft:
                return False, blksleft
            ans, blksleft = _abc(whatsleft, blksleft)
            if ans:
                return ans, blksleft
        else:
            break
    return False, blocks

def abc(word, blocks=BLOCKS):
    return _abc(word.upper(), blocks)[0]

if __name__ == '__main__':
    for word in [''] + 'A BARK BoOK TrEAT COmMoN SQUAD conFUsE'.split():
        print('Can we spell %9r? %r' % (word, abc(word)))
