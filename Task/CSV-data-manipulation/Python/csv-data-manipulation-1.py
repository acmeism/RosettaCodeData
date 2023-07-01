import fileinput

changerow, changecolumn, changevalue = 2, 4, '"Spam"'

with fileinput.input('csv_data_manipulation.csv', inplace=True) as f:
    for line in f:
        if fileinput.filelineno() == changerow:
            fields = line.rstrip().split(',')
            fields[changecolumn-1] = changevalue
            line = ','.join(fields) + '\n'
        print(line, end='')
