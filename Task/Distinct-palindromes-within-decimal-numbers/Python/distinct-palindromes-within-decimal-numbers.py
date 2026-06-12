def is_palindrome(s: str):
    return s == s[::-1]

def main():
    for i in range(100, 126):
        s = str(i)

        print(s, '=>', end=' ')

        palindromes = []

        for ii in range(len(s)):
            for j in range(ii+1, len(s)+1):
                substr = s[ii:j]

                if is_palindrome(substr):
                    if substr not in palindromes:
                        palindromes.append(substr)

        print(' '.join(sorted(palindromes)))

    nums = sorted(
        {
            "9", "169", "12769", "1238769", "123498769", "12346098769",
            "1234572098769", "123456832098769", "12345679432098769",
            "1234567905432098769", "123456790165432098769",
            "83071934127905179083", "1320267947849490361205695"
        },
        key=lambda s: len(s)
    )

    print("\nHas no >= 2 digit palindromes\n")

    for num in nums:
        has_no_palindromes = True

        for i in range(len(num)):
            for j in range(i+2, len(num)):
                substr = num[i:j]
                if is_palindrome(substr):
                    has_no_palindromes = False
                    break

            if not has_no_palindromes:
                break

        print(num, ':', has_no_palindromes)

if __name__ == '__main__':
    main()
