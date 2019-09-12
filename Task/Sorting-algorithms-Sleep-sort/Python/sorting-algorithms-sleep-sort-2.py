#!/usr/bin/env python3
from asyncio import run, sleep, wait
from sys import argv

async def f(n):
    await sleep(n)
    print(n)

if __name__ == '__main__':
    run(wait(list(map(f, map(int, argv[1:])))))
