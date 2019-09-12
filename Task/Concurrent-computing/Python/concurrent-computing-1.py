import asyncio


async def print_(string: str) -> None:
    print(string)


async def main():
    strings = ['Enjoy', 'Rosetta', 'Code']
    coroutines = map(print_, strings)
    await asyncio.gather(*coroutines)


if __name__ == '__main__':
    asyncio.run(main())
