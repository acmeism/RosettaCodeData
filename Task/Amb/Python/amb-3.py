def main():
    print (
        unlines([
            unwords([w1, w2, w3, w4])

            for w1 in ['the', 'that', 'a']
            if True

            for w2 in ['frog', 'elephant', 'thing']
            if joins(w1, w2)

            for w3 in ['walked', 'treaded', 'grows']
            if joins(w2, w3)

            for w4 in ['slowly', 'quickly']
            if joins(w3, w4)
        ])
    )


# joins :: String -> String -> Bool
def joins(a, b):
    return a[-1] == b[0]


# unlines :: [String] -> String
def unlines(xs):
    return '\n'.join(xs)


# unwords :: [String] -> String
def unwords(xs):
    return ' '.join(xs)


if __name__ == '__main__':
    main()
