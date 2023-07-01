if __name__ == '__main__':
    parse_and_solve("""
        Baker, Cooper, Fletcher, Miller, and Smith
        live on different floors of an apartment house that contains
        only five floors. Baker does not live on the top floor. Cooper
        does not live on the bottom floor. Fletcher does not live on
        either the top or the bottom floor. Miller lives on a higher
        floor than does Cooper. Smith does not live on a floor
        adjacent to Fletcher's. Fletcher does not live on a floor
        adjacent to Cooper's. Where does everyone live?""")

    print('# Add another person with more constraints and more floors:')
    parse_and_solve("""
        Baker, Cooper, Fletcher, Miller, Guinan, and Smith
        live on different floors of an apartment house that contains
        only seven floors. Guinan does not live on either the top or the third or the fourth floor.
        Baker does not live on the top floor. Cooper
        does not live on the bottom floor. Fletcher does not live on
        either the top or the bottom floor. Miller lives on a higher
        floor than does Cooper. Smith does not live on a floor
        adjacent to Fletcher's. Fletcher does not live on a floor
        adjacent to Cooper's. Where does everyone live?""")
