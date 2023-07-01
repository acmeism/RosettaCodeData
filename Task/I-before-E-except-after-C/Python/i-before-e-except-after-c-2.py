def stretch_stats(url='http://ucrel.lancs.ac.uk/bncfreq/lists/1_2_all_freq.txt'):
    freq = [line.strip().lower().split()
            for line in urllib.request.urlopen(url)
            if len(line.strip().split()) == 3]
    wordfreq = [(word.decode(), int(frq))
                for word, pos, frq in freq[1:]
                if (b'ie' in word) or (b'ei' in word)]
    cie = sum(frq for word, frq in wordfreq if 'cie' in word)
    cei = sum(frq for word, frq in wordfreq if 'cei' in word)
    not_c_ie = sum(frq for word, frq in wordfreq if re.search(r'(^ie|[^c]ie)', word))
    not_c_ei = sum(frq for word, frq in wordfreq if re.search(r'(^ei|[^c]ei)', word))
    return cei, cie, not_c_ie, not_c_ei

print('\n\nChecking plausibility of "I before E except after C"')
print('And taking account of word frequencies in British English:')
print_result(*stretch_stats())
