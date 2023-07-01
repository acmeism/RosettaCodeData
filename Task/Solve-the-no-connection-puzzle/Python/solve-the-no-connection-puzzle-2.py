def pp(solution):
    """Prettyprint a solution"""
    boardformat = r"""
         A   B
        /|\ /|\
       / | X | \
      /  |/ \|  \
     C - D - E - F
      \  |\ /|  /
       \ | X | /
        \|/ \|/
         G   H"""
    for letter, number in zip("ABCDEFGH", solution):
        boardformat = boardformat.replace(letter, str(number))
    print(boardformat)


if __name__ == '__main__':
    for i, s in enumerate(solutions, 1):
        print("\nSolution", i, end='')
        pp(s)
