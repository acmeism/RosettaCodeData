#!/usr/bin/env python3
from unicodedata import name


def unicode_code(ch):
    return 'U+{:04x}'.format(ord(ch))


def utf8hex(ch):
    return " ".join([hex(c)[2:] for c in ch.encode('utf8')]).upper()


if __name__ == "__main__":
    print('{:<11} {:<36} {:<15} {:<15}'.format('Character', 'Name', 'Unicode', 'UTF-8 encoding (hex)'))
    chars = ['A', 'ö', 'Ж', '€', '𝄞']
    for char in chars:
        print('{:<11} {:<36} {:<15} {:<15}'.format(char, name(char), unicode_code(char), utf8hex(char)))
