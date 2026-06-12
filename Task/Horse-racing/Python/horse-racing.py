import enum

class Gender(enum.Enum):
    COLT: int = 1
    FILLY: int = 2

class Info:
    __slots__ = ["gender", "rating"]

    def __init__(self, gender, rating):
        self.gender: Gender = gender
        self.rating: float = rating

    # Not needed, but helpful for debugging issues.
    def __repr__(self) -> str:
        return f"({self.gender}, {self.rating})"

def gender_to_string(gender: Gender) -> str:
    if gender == Gender.COLT:
        return "Colt"

    # elif gender == Gender.FILLY
    return "Filly"

def main() -> None:
    # dict of horse stats after first 3 races
    HORSES: dict[str, Info] = {
        "A": Info(Gender.COLT, 100.0),
        "B": Info(Gender.FILLY, 88.0),
        "C": Info(Gender.COLT, 97.0),
        "D": Info(Gender.FILLY, 92.0),
        "E": Info(Gender.COLT, 97.0),
        "F": Info(Gender.COLT, 99.0),
        "G": Info(Gender.COLT, 92.0),
        "H": Info(Gender.COLT, 95.0),
        "I": Info(Gender.FILLY, 103.0),
        "J": Info(Gender.FILLY, 0.0)
    }

    # Make adjustments to the ratings after Race 4
    HORSES["B"].rating += 4.0
    HORSES["C"].rating -= 4.0
    HORSES["H"].rating += 3.0
    HORSES["J"].rating += 99.0


    # Make weight allowance adjustment for horses with Gender.FILLY
    for horse in HORSES:
        if HORSES[horse].gender == Gender.FILLY:
            HORSES[horse].rating += 3.0

    # Sort in descending order of rating by converting
    # the HORSES dictionary to a list.
    HORSES = [[horse, HORSES[horse]] for horse in HORSES]
    HORSES = sorted(HORSES, key = lambda horse: horse[1].rating)[::-1]

    # Display the expected result for Race 4
    print("Race 4:\n\n", end = "")
    print("Position  Horse  Weight  Distance  Gender\n", end = "")

    for i in range(len(HORSES)):
        entry: list[str, Info] = HORSES[i]
        weight: float = "9.00" if entry[1].gender == Gender.COLT else 8.11
        gender: str = gender_to_string(entry[1].gender)

        if i:
            distance: float = (HORSES[i - 1][1].rating - entry[1].rating) * 0.5

        else:
            distance: float = 0.0

        if i == 0 or distance > 0.0:
            pos: str = str(i + 1)

        else:
            pos: str = str(i) + "="

        print(f"{pos:^6}", end = "")
        print(f"{entry[0]:>7}", end = "")
        print(f"{weight:>9}", end = "")
        print(f"{distance:>7}", end = "")
        print(f"{gender + " " * (5 - len(gender)):>12}")

    # Weight adjusted rating of the horse that won.
    rating: float = HORSES[0][1].rating

    # Expected time of the winning horse. This is calculated
    # by comparison to horse A's time in race 1.
    time: float = 96 - (rating - 100) / 10

    print(
        f"\nTime: {int(time / 60)} minute" + "s" * (int(time / 60) > 1) + \
        f" {(time % 60):.1f} seconds"
    )

if __name__ == "__main__":
    main()
