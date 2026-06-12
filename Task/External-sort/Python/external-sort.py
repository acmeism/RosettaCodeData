#! /usr/bin/python3

'''
    $ # example session in bash
    $ python3 external_sort.py
    expect 123456789
    memory size 1 passed
    memory size 2 passed
    memory size 3 passed
    memory size 4 passed
    memory size 5 passed
    memory size 6 passed
    memory size 7 passed
    memory size 8 passed
    memory size 9 passed
    memory size 10 passed
    memory size 11 passed
'''

import io

def sort_large_file(n: int, source: open, sink: open, file_opener = open)->None:

    '''
        approach:
            break the source into files of size n
            sort each of these files
            merge these onto the sink
    '''

    # store sorted chunks into files of size n
    mergers = []
    while True:
        text = list(source.read(n))
        if not len(text):
            break;
        text.sort()
        merge_me = file_opener()
        merge_me.write(''.join(text))
        mergers.append(merge_me)
        merge_me.seek(0)

    # merge onto sink
    stack_tops = [f.read(1) for f in mergers]
    while stack_tops:
        c = min(stack_tops)
        sink.write(c)
        i = stack_tops.index(c)
        t = mergers[i].read(1)
        if t:
            stack_tops[i] = t
        else:
            del stack_tops[i]
            mergers[i].close()
            del mergers[i]  # __del__ method of file_opener should delete the file

def main():
    '''
        test case
        sort 6,7,8,9,2,5,3,4,1 with several memory sizes
    '''

    # load test case into a file like object
    input_file_too_large_for_memory = io.StringIO('678925341')

    # generate the expected output
    t = list(input_file_too_large_for_memory.read())
    t.sort()
    expect = ''.join(t)
    print('expect', expect)

    # attempt to sort with several memory sizes
    for memory_size in range(1,12):
        input_file_too_large_for_memory.seek(0)
        output_file_too_large_for_memory = io.StringIO()
        sort_large_file(memory_size, input_file_too_large_for_memory, output_file_too_large_for_memory, io.StringIO)
        output_file_too_large_for_memory.seek(0)
        assert(output_file_too_large_for_memory.read() == expect)
        print('memory size {} passed'.format(memory_size))

if __name__ == '__main__':
   example = main
   example()
