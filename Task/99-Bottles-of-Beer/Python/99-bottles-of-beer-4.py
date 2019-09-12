"""99 Bottles of Beer on the Wall made functional"""
from functools import partial
from typing import Callable


def regular_plural(noun: str) -> str:
    """Regular rule to get the plural form of a word"""
    return noun + "s"


def beer_song(*,
              location: str = 'on the wall',
              distribution: str = 'Take one down, pass it around',
              solution: str = 'Better go to the store to buy some more!',
              container: str = 'bottle',
              plurifier: Callable[[str], str] = regular_plural,
              liquid: str = "beer",
              initial_count: int = 99) -> None:
    """
    Displays the lyrics of the beer song
    :param location: initial location of the drink
    :param distribution: specifies the process of its distribution
    :param solution: what happens when we run out of drinks
    :param container: bottle/barrel/flask or other containers
    :param plurifier: function converting a word to its plural form
    :param liquid: the name of the drink in the given container
    :param initial_count: how many containers available initially
    """
    verse = partial(get_verse,
                    location=location,
                    distribution=distribution,
                    solution=solution,
                    container=container,
                    plurifier=plurifier,
                    liquid=liquid)
    verses = map(verse, range(initial_count, -1, -1))
    print(*verses, sep='\n\n')


def get_verse(count: int,
              *,
              location: str,
              distribution: str,
              solution: str,
              container: str,
              plurifier: Callable[[str], str],
              liquid: str) -> str:
    """Returns the verse for the given initial amount of drinks"""
    inventory = partial(get_inventory,
                        location=location)
    asset = partial(get_asset,
                    container=container,
                    plurifier=plurifier,
                    liquid=liquid)
    initial_asset = asset(count)
    final_asset = asset(count - 1)
    standard_verse = '\n'.join([inventory(initial_asset),
                                initial_asset,
                                distribution,
                                inventory(final_asset)])
    return solution if count == 0 else standard_verse


def get_inventory(asset: str,
                  *,
                  location: str) -> str:
    """
    Used to return the first or the fourth line of the verse

    >>> get_inventory("10 bottles of beer", location="on the wall")
    "10 bottles of beer on the wall"
    """
    return ' '.join([asset, location])


def get_asset(count: int,
              *,
              container: str,
              plurifier: Callable[[str], str],
              liquid: str) -> str:
    """
    Quantified asset

    >>> get_asset(0, container="jar", plurifier=regular_plural, liquid='milk')
    "No more jars of milk"
    """
    containers = container if count == 1 else plurifier(container)
    spelled_out_quantity = "No more" if count == 0 else str(count)
    return ' '.join([spelled_out_quantity, containers, "of", liquid])


if __name__ == '__main__':
    beer_song()
