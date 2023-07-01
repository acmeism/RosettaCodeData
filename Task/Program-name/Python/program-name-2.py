#!/usr/bin/env python

import inspect

def main():
    program = inspect.getfile(inspect.currentframe())
    print("Program: %s" % program)

if __name__ == "__main__":
    main()
