#!/bin/env -S python3

#
# Reference:
#
#   A. F. Kracklauer, ‘EPR-B correlations: non-locality or geometry?’,
#   J. Nonlinear Math. Phys. 11 (Supp.) 104–109 (2004).
#   https://doi.org/10.2991/jnmp.2004.11.s1.13 (Open access, CC BY-NC)
#

import sys
from math import atan2, cos, floor, pi, radians, sin, sqrt

class PulseData():
    '''The data for one light pulse.'''

    def __init__(self, logS, logL, logR, detectedL1, detectedL2,
                 detectedR1, detectedR2):
        self.logS = logS
        self.logL = logL
        self.logR = logR
        self.detectedL1 = detectedL1
        self.detectedL2 = detectedL2
        self.detectedR1 = detectedR1
        self.detectedR2 = detectedR2

    def __repr__(self):
        return ("PulseData(" + str(self.logS) + ", "
                + str(self.logL) + ", "
                + str(self.logR) + ", "
                + str(self.detectedL1) + ", "
                + str(self.detectedL2) + ", "
                + str(self.detectedR1) + ", "
                + str(self.detectedR2) + ")")

    def swap_L_channels(self):
        '''Swap detectedL1 and detectedL2.'''
        (self.detectedL1, self.detectedL2) = \
            (self.detectedL2, self.detectedL1)

    def swap_R_channels(self):
        '''Swap detectedR1 and detectedR2.'''
        (self.detectedR1, self.detectedR2) = \
            (self.detectedR2, self.detectedR1)

    def swap_LR_channels(self):
        '''Swap channels on both right and left. This is done if the
        light source was (1,90°) instead of (1,0°). For in that case
        the orientations of the polarizing beam splitters, relative to
        the light source, is different by 90°.'''
        self.swap_L_channels()
        self.swap_R_channels()

def split_data(predicate, data):
    '''Split the data into two subsets, according to whether a set
    item satisfies a predicate. The return value is a tuple, with
    those items satisfying the predicate in the first tuple entry, the
    other items in the second entry.

    '''
    subset1 = {x for x in data if predicate(x)}
    subset2 = data - subset1
    return (subset1, subset2)

def adjust_data_for_light_pulse_orientation(data):
    '''Some data items are for a (1,0°) light pulse. The others are
    for a (1,90°) light pulse. Thus the light pulses are oriented
    differently with respect to the polarizing beam splitters. We
    adjust for that distinction here.'''
    data0, data90 = split_data(lambda item: item.logS == 0, data)
    for item in data90:
        item.swap_LR_channels()
    return (data0 | data90)     # Set union.

def split_data_according_to_PBS_setting(data):
    '''Split the data into four subsets: one subset for each
    arrangement of the two polarizing beam splitters.'''
    dataL1, dataL2 = split_data(lambda item: item.logL == 0, data)
    dataL1R1, dataL1R2 = \
        split_data(lambda item: item.logR == 0, dataL1)
    dataL2R1, dataL2R2 = \
        split_data(lambda item: item.logR == 0, dataL2)
    return (dataL1R1, dataL1R2, dataL2R1, dataL2R2)

def compute_correlation_coefficient(angleL, angleR, data):
    '''Compute the correlation coefficient for the subset of the data
    that corresponding to a particular setting of the polarizing beam
    splitters.'''

    # We make certain the orientations of beam splitters are
    # represented by perpendicular angles in the first and fourth
    # quadrant. This restriction causes no loss of generality, because
    # the orientation of the beam splitter is actually a rotated "X".
    assert (all(0 <= x and x < 90 for x in (angleL, angleR)))
    #perpendicularL = angleL - 90 # In Quadrant 4.
    #perpendicularR = angleR - 90 # In Quadrant 4.

    # Note that the sine is non-negative in Quadrant 1, and the cosine
    # is non-negative in Quadrant 4. Thus we can use the following
    # estimates for cosine and sine. This is Equation (2.4) in the
    # reference. (Note, one can also use Quadrants 1 and 2 and reverse
    # the roles of cosine and sine. And so on like that.)
    N = len(data)
    NL1 = 0
    NL2 = 0
    NR1 = 0
    NR2 = 0
    for item in data:
        NL1 += item.detectedL1
        NL2 += item.detectedL2
        NR1 += item.detectedR1
        NR2 += item.detectedR2
    sinL = sqrt(NL1 / N)
    cosL = sqrt(NL2 / N)
    sinR = sqrt(NR1 / N)
    cosR = sqrt(NR2 / N)

    # Now we can apply the reference's Equation (2.3).
    cosLR = (cosR * cosL) + (sinR * sinL)
    sinLR = (sinR * cosL) - (cosR * sinL)

    # And then Equation (2.5).
    kappa = (cosLR * cosLR) - (sinLR * sinLR)

    return kappa

def read_raw_data(filename):
    '''Read the raw data. Its order does not actually matter, so we
    return the data as a set.'''

    def make_record(line):
        x = line.split()
        record = PulseData(logS = int(x[0]),
                           logL = int(x[1]),
                           logR = int(x[2]),
                           detectedL1 = int(x[3]),
                           detectedL2 = int(x[4]),
                           detectedR1 = int(x[5]),
                           detectedR2 = int(x[6]))
        return record

    def read_data(f):
        num_pulses = int(f.readline())
        data = set()
        for i in range(num_pulses):
            data.add(make_record(f.readline()))
        return data

    if filename != "-":
        with open(filename, "r") as f:
            data = read_data(f)
    else:
        data = read_data(sys.stdin)
    return data

if __name__ == '__main__':

    if len(sys.argv) != 1 and len(sys.argv) != 2:
        print("Usage: " + sys.argv[0] + " [RAW_DATA_FILE]")
        sys.exit(1)
    raw_data_filename = (sys.argv[1] if len(sys.argv) == 2 else "-")

    # Polarizing beam splitter orientations commonly used in actual
    # experiments. These must match the values used in the simulation
    # itself. They are by design all either zero degrees or in the
    # first quadrant.
    anglesL = (0.0, 45.0)
    anglesR = (22.5, 67.5)
    assert (all(0 <= x and x < 90 for x in anglesL + anglesR))

    data = read_raw_data(raw_data_filename)
    data = adjust_data_for_light_pulse_orientation(data)
    dataL1R1, dataL1R2, dataL2R1, dataL2R2 = \
        split_data_according_to_PBS_setting(data)

    kappaL1R1 = \
        compute_correlation_coefficient (anglesL[0], anglesR[0],
                                         dataL1R1)
    kappaL1R2 = \
        compute_correlation_coefficient (anglesL[0], anglesR[1],
                                         dataL1R2)
    kappaL2R1 = \
        compute_correlation_coefficient (anglesL[1], anglesR[0],
                                         dataL2R1)
    kappaL2R2 = \
        compute_correlation_coefficient (anglesL[1], anglesR[1],
                                         dataL2R2)

    chsh_contrast = -kappaL1R1 + kappaL1R2 + kappaL2R1 + kappaL2R2

    # The nominal value of the CHSH contrast for the chosen polarizer
    # orientations is 2*sqrt(2).
    chsh_contrast_nominal = 2 * sqrt(2.0)

    print()
    print("   light pulse events   %9d" % len(data))
    print()
    print("    correlation coefs")
    print("          %4.1f° %4.1f°   %+9.6f" % (anglesL[0], anglesR[0],
                                                kappaL1R1))
    print("          %4.1f° %4.1f°   %+9.6f" % (anglesL[0], anglesR[1],
                                                kappaL1R2))
    print("          %4.1f° %4.1f°   %+9.6f" % (anglesL[1], anglesR[0],
                                                kappaL2R1))
    print("          %4.1f° %4.1f°   %+9.6f" % (anglesL[1], anglesR[1],
                                                kappaL2R2))
    print()
    print("        CHSH contrast   %+9.6f" % chsh_contrast)
    print("  2*sqrt(2) = nominal   %+9.6f" % chsh_contrast_nominal)
    print("           difference   %+9.6f" % (chsh_contrast -
                                              chsh_contrast_nominal))

    # A "CHSH violation" occurs if the CHSH contrast is >2.
    # https://en.wikipedia.org/w/index.php?title=CHSH_inequality&oldid=1142431418
    print()
    print("       CHSH violation   %+9.6f" % (chsh_contrast - 2))
    print()
