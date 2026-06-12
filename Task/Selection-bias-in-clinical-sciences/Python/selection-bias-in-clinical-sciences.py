''' Rosetta code rosettacode.org/wiki/Study_Bias_in_Clinical_Sciences '''


from random import randrange
from numpy.random import rand
from scipy.stats import kruskal

UNTREATED = 0
IRREGULAR = 1
REGULAR = 2
DOSE_FOR_REGULAR = 100


class Subject:
    ''' A subject for the study '''

    def __init__(self):
        self.cum_dose = 0.0
        self.category = UNTREATED
        self.had_covid = False
        self.update_count = 0

    def update(self, p_covid=0.001, p_starting_treatment=0.005, p_redose=0.25, drange=(3, 10, 3)):
        ''' daily update on the subject to check for infection and randomly dose. '''
        if not self.had_covid:
            if rand() < p_covid:
                self.had_covid = True
            elif (self.cum_dose == 0 and rand() < p_starting_treatment) or\
                 (self.cum_dose > 0 and rand() < p_redose):
                self.cum_dose += randrange(*drange)
                self.categorize()
        self.update_count += 1

    def categorize(self):
        ''' Set treatment category based on cumulative treatment taken. '''
        self.category = UNTREATED if self.cum_dose == 0 else REGULAR if\
            self.cum_dose >= DOSE_FOR_REGULAR else IRREGULAR
        return self.category


def run_study(num_subjects=1000, duration=180, interval=30):
    ''' Run the study using the population of size `N` for `duration` days. '''
    population = [Subject() for _ in range(num_subjects)]
    unt, unt_covid, irr, irr_covid, reg, reg_covid = 0, 0, 0, 0, 0, 0
    print(f'Total subjects: {num_subjects:,}')
    for day in range(duration):
        for subj in population:
            subj.update()

        if (day + 1) % interval == 0:
            print(f'\nDay {day + 1}:')
            unt = sum(s.category == UNTREATED for s in population)
            unt_covid = sum(s.category ==
                            UNTREATED and s.had_covid for s in population)
            print(f'Untreated: N = {unt}, with infection = {unt_covid}')
            irr = sum(s.category == IRREGULAR for s in population)
            irr_covid = sum(s.category ==
                            IRREGULAR and s.had_covid for s in population)
            print(f'Irregular Use: N = {irr}, with infection = {irr_covid}')
            reg = sum(s.category == REGULAR for s in population)
            reg_covid = sum(s.category ==
                            REGULAR and s.had_covid for s in population)
            print(f'Regular Use: N = {reg}, with infection = {reg_covid}')

        if day == duration // 2 - 1:
            print('\nAt midpoint, Infection case percentages are:')
            print('  Untreated : ', 100 * unt_covid / unt)
            print('  Irregulars: ', 100 * irr_covid / irr)
            print('  Regulars  : ', 100 * reg_covid / reg)

    print('\nAt study end, Infection case percentages are:')
    print(f'  Untreated : {100 * unt_covid / unt} of group size of {unt}')
    print(f'  Irregulars: {100 * irr_covid / irr} of group size of {irr}')
    print(f'  Regulars  : {100 * reg_covid / reg} of group size of {reg}')
    untreated = [
        s.had_covid for s in population if s.category == UNTREATED]
    irregular = [
        s.had_covid for s in population if s.category == IRREGULAR]
    regular = [s.had_covid for s in population if s.category == REGULAR]
    print('\nFinal statistics: ', kruskal(untreated, irregular, regular))


run_study()
