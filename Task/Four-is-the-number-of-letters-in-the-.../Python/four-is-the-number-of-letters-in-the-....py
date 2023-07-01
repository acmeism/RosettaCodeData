# Python implementation of Rosetta Code Task
# http://rosettacode.org/wiki/Four_is_the_number_of_letters_in_the_...
# Uses inflect
# https://pypi.org/project/inflect/

import inflect

def count_letters(word):
    """
    count letters ignore , or -, or space
    """
    count = 0
    for letter in word:
        if letter != ',' and letter !='-' and letter !=' ':
            count += 1

    return count

def split_with_spaces(sentence):
    """
    Takes string with partial sentence and returns
    list of words with spaces included.

    Leading space is attached to first word.
    Later spaces attached to prior word.
    """
    sentence_list = []
    curr_word = ""
    for c in sentence:
        if c == " " and curr_word != "":
            # append space to end of non-empty words
            # assumed no more than 1 consecutive space.
            sentence_list.append(curr_word+" ")
            curr_word = ""
        else:
            curr_word += c

    # add trailing word that does not end with a space

    if len(curr_word) > 0:
        sentence_list.append(curr_word)

    return sentence_list

def my_num_to_words(p, my_number):
    """
    Front end to inflect's number_to_words

    Get's rid of ands and commas in large numbers.
    """

    number_string_list = p.number_to_words(my_number, wantlist=True, andword='')

    number_string = number_string_list[0]

    for i in range(1,len(number_string_list)):
        number_string += " " + number_string_list[i]

    return number_string

def build_sentence(p, max_words):
    """

    Builds at most max_words of the task following the pattern:

    Four is the number of letters in the first word of this sentence, two in the second,
    three in the third, six in the fourth, two in the fifth, seven in the sixth,

    """

    # start with first part of sentence up first comma as a list

    sentence_list = split_with_spaces("Four is the number of letters in the first word of this sentence,")

    num_words = 13

    # which word number we are doing next
    # two/second is first one in loop

    word_number = 2

    # loop until sentance is at least as long as needs be

    while num_words < max_words:
        # Build something like
        # ,two in the second

        # get second or whatever we are on

        ordinal_string = my_num_to_words(p, p.ordinal(word_number))

        # get two or whatever the length is of the word_number word

        word_number_string = my_num_to_words(p, count_letters(sentence_list[word_number - 1]))

        # sentence addition

        new_string = " "+word_number_string+" in the "+ordinal_string+","

        new_list = split_with_spaces(new_string)

        sentence_list += new_list

        # add new word count

        num_words += len(new_list)

        # increment word number

        word_number += 1

    return sentence_list, num_words

def word_and_counts(word_num):
    """

    Print's lines like this:

    Word     1000 is "in", with 2 letters.  Length of sentence so far: 6279

    """

    sentence_list, num_words = build_sentence(p, word_num)

    word_str = sentence_list[word_num - 1].strip(' ,')

    num_letters = len(word_str)

    num_characters = 0

    for word in sentence_list:
       num_characters += len(word)

    print('Word {0:8d} is "{1}", with {2} letters.  Length of the sentence so far: {3}  '.format(word_num,word_str,num_letters,num_characters))


p = inflect.engine()

sentence_list, num_words = build_sentence(p, 201)

print(" ")
print("The lengths of the first 201 words are:")
print(" ")

print('{0:3d}:  '.format(1),end='')

total_characters = 0

for word_index in range(201):

    word_length = count_letters(sentence_list[word_index])

    total_characters += len(sentence_list[word_index])

    print('{0:2d}'.format(word_length),end='')
    if (word_index+1) % 20 == 0:
        # newline every 20
        print(" ")
        print('{0:3d}:  '.format(word_index + 2),end='')
    else:
        print(" ",end='')

print(" ")
print(" ")
print("Length of the sentence so far: "+str(total_characters))
print(" ")

"""

Expected output this part:

Word     1000 is "in", with 2 letters.  Length of the sentence so far: 6279
Word    10000 is "in", with 2 letters.  Length of the sentence so far: 64140
Word   100000 is "one", with 3 letters.  Length of the sentence so far: 659474
Word  1000000 is "the", with 3 letters.  Length of the sentence so far: 7113621
Word 10000000 is "thousand", with 8 letters.  Length of the sentence so far: 70995756

"""

word_and_counts(1000)
word_and_counts(10000)
word_and_counts(100000)
word_and_counts(1000000)
word_and_counts(10000000)
