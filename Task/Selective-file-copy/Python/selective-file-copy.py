def process(line: str):
    a = line[:5]
    n = int(line[14:15] + line[10:14])

    return "%s%5dXXXXX" % (a, n)


def main():
    with open('selective_output.txt', 'w+') as out:
        with open('selective_input.txt', 'r') as in_file:
            for line in in_file:
                out.write(process(line) + '\n')

        out.seek(0)
        print(out.read())

if __name__ == '__main__':
    main()
