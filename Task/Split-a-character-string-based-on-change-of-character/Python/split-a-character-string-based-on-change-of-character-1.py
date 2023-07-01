from itertools import groupby

def splitter(text):
    return ', '.join(''.join(group) for key, group in groupby(text))

if __name__ == '__main__':
    txt = 'gHHH5YY++///\\'      # Note backslash is the Python escape char.
    print(f'Input: {txt}\nSplit: {splitter(txt)}')
