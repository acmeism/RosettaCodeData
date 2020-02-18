"""
    99 Bottles of Beer on the Wall made functional

    Main function accepts a number of parameters, so you can specify a name of
    the drink, its container and other things. English only.
"""

from functools import partial
from typing import Callable


def regular_plural(noun: str) -> str:
    """English rule to get the plural form of a word"""
    if noun[-1] == "s":
        return noun + "es"

    return noun + "s"


def beer_song(
    *,
    location: str = 'on the wall',
    distribution: str = 'Take one down, pass it around',
    solution: str = 'Better go to the store to buy some more!',
    container: str = 'bottle',
    plurifier: Callable[[str], str] = regular_plural,
    liquid: str = "beer",
    initial_count: int = 99,
) -> str:
    """
    Return the lyrics of the beer song
    :param location: initial location of the drink
    :param distribution: specifies the process of its distribution
    :param solution: what happens when we run out of drinks
    :param container: bottle/barrel/flask or other containers
    :param plurifier: function converting a word to its plural form
    :param liquid: the name of the drink in the given container
    :param initial_count: how many containers available initially
    """

    verse = partial(
        get_verse,
        initial_count = initial_count,
        location = location,
        distribution = distribution,
        solution = solution,
        container = container,
        plurifier = plurifier,
        liquid = liquid,
    )

    verses = map(verse, range(initial_count, -1, -1))
    return '\n\n'.join(verses)


def get_verse(
    count: int,
    *,
    initial_count: str,
    location: str,
    distribution: str,
    solution: str,
    container: str,
    plurifier: Callable[[str], str],
    liquid: str,
) -> str:
    """Returns the verse for the given amount of drinks"""

    asset = partial(
        get_asset,
        container = container,
        plurifier = plurifier,
        liquid = liquid,
    )

    current_asset = asset(count)
    next_number = count - 1 if count else initial_count
    next_asset = asset(next_number)
    action = distribution if count else solution

    inventory = partial(
        get_inventory,
        location = location,
    )

    return '\n'.join((
        inventory(current_asset),
        current_asset,
        action,
        inventory(next_asset),
    ))


def get_inventory(
    asset: str,
    *,
    location: str,
) -> str:
    """
    Used to return the first or the fourth line of the verse

    >>> get_inventory("10 bottles of beer", location="on the wall")
    "10 bottles of beer on the wall"
    """
    return ' '.join((asset, location))


def get_asset(
    count: int,
    *,
    container: str,
    plurifier: Callable[[str], str],
    liquid: str,
) -> str:
    """
    Quantified asset

    >>> get_asset(0, container="jar", plurifier=regular_plural, liquid='milk')
    "No more jars of milk"
    """

    containers = plurifier(container) if count != 1 else container
    spelled_out_quantity = str(count) if count else "No more"
    return ' '.join((spelled_out_quantity, containers, "of", liquid))


if __name__ == '__main__':
    print(beer_song())
