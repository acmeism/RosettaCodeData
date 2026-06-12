#!/bin/env -S python3

#
# Reference:
#
#   A. F. Kracklauer, ‘EPR-B correlations: non-locality or geometry?’,
#   J. Nonlinear Math. Phys. 11 (Supp.) 104–109 (2004).
#   https://doi.org/10.2991/jnmp.2004.11.s1.13 (Open access, CC BY-NC)
#

import sys
import multiprocessing as mp
import time as tm
from math import atan2, cos, floor, pi, radians, sin, sqrt
from random import randint, seed, uniform

def modulo(a, p):
    '''This is like the MODULO function of Fortran.'''
    return (a - (floor(a / p) * p));

class Vector:
    '''A simple implementation of Gibbs vectors, suited to our
    purpose.'''

    def __init__(self, magnitude, angle):
        '''A vector is stored in polar form, with the angle in
        degrees between 0 (inclusive) and 360 (exclusive).'''
        self.magnitude = magnitude
        self.angle = modulo(angle, 360)

    def __repr__(self):
        return ("Vector(" + str(self.magnitude)
                + "," + str(self.angle) + ")")

    @staticmethod
    def from_rect(x, y):
        '''Return a vector for the given rectangular coordinates.'''
        return Vector(sqrt(x**2 + y**2),
                      modulo (180 * pi * atan2 (y, x), 360))

    def to_rect(self):
        '''Return the x and y coordinates of the vector.'''
        x = self.magnitude * cos ((pi / 180) * self.angle)
        y = self.magnitude * sin ((pi / 180) * self.angle)
        return (x, y)

    @staticmethod
    def scalar_product(vector, scalar):
        '''Multiply a vector by a scalar, returning a new vector.'''
        return Vector(vector.magnitude * scalar, vector.angle)

    @staticmethod
    def dot_product(u, v):
        '''Return the dot product of two vectors.'''
        return (u.magnitude * v.magnitude
                * cos ((pi / 180) * (u.angle - v.angle)))

    @staticmethod
    def difference(u, v):
        '''Return the difference of two vectors.'''
        (xu, yu) = u.to_rect()
        (xv, yv) = v.to_rect()
        return Vector.from_rect(xu - xv, yu - yv)

    @staticmethod
    def projection(u, v):
        '''Return the projection of vector u onto vector v.'''
        scalar = Vector.dot_product(u, v) / Vector.dot_product(v, v)
        return Vector.scalar_product(v, scalar)

class Mechanism:
    '''A Mechanism represents a part of the experimental apparatus.'''

    def __call__(self):
        '''Run the mechanism.'''
        while True:
            self.run()
            # A small pause to try not to overtax the computer.
            tm.sleep(0.001)

    def run(self):
        '''Fill this in with what the mechanism does.'''
        raise NotImplementedError()

class LightSource(Mechanism):
    '''A LightSource occasionally emits oppositely plane-polarized
    light pulses, of fixed amplitude, polarized 90° with respect to
    each other. The pulses are represented by the vectors (1,0°) and
    (1,90°), respectively. One is emitted to the left, the other to
    the right. The probability is 1/2 that the (1,0°) pulse is emitted
    to the left.

    The LightSource records which pulse it emitted in which direction.

    '''

    def __init__(self, L, R, log):
        Mechanism.__init__(self)
        self.L = L         # Queue gets (1,0°) or (1,90°)
        self.R = R         # Queue gets (1,90°) or (1,0°)
        self.log = log     # Queue gets 0 if (1,0°) sent left, else 1.

    def run(self):
        '''Emit a light pulse.'''
        n = randint(0, 1)
        self.L.put(Vector(1, n * 90))
        self.R.put(Vector(1, 90 - (n * 90)))
        self.log.put(n)

class PolarizingBeamSplitter(Mechanism):
    '''A polarizing beam splitter takes a plane-polarized light pulse
    and splits it into two plane-polarized pulses. The directions of
    polarization of the two output pulses are determined solely by the
    angular setting of the beam splitter—NOT by the angle of the
    original pulse. However, the amplitudes of the output pulses
    depend on the angular difference between the impinging light pulse
    and the beam splitter.

    Each beam splitter is designed to select randomly between one of
    two angle settings. It records which setting it selected (by
    putting that information into one of its output queues).

    '''

    def __init__(self, S, S1, S2, log, angles):
        Mechanism.__init__(self)
        self.S = S              # Vector queue to read from.
        self.S1 = S1            # One vector queue out.
        self.S2 = S2            # The other vector queue out.
        self.log = log          # Which angle setting was used.
        self.angles = angles

    def run(self):
        '''Split a light pulse into two pulses. One of output pulses
        may be visualized as the vector projection of the input pulse
        onto the direction vector of the beam splitter. The other
        output pulse is the difference between the input pulse and the
        first output pulse: in other words, the orthogonal component.'''

        angle_setting = randint(0, 1)
        self.log.put(angle_setting)

        angle = self.angles[angle_setting]
        assert (0 <= angle and angle < 90)

        v = self.S.get()
        v1 = Vector.projection(v, Vector(1, angle))
        v2 = Vector.difference(v, v1)

        self.S1.put(v1)
        self.S2.put(v2)

class LightDetector(Mechanism):
    '''Our light detector is assumed to work as follows: if a
    uniformly distributed random number between 0 and 1 is less than
    or equal to the intensity (square of the amplitude) of an
    impinging light pulse, then the detector outputs a 1, meaning the
    pulse was detected. Otherwise it outputs a 0, representing the
    quiescent state of the detector.

    '''

    def __init__(self, In, Out):
        Mechanism.__init__(self)
        self.In = In
        self.Out = Out

    def run(self):
        '''When a light pulse comes in, either detect it or do not.'''
        pulse = self.In.get()
        intensity = pulse.magnitude**2
        self.Out.put(1 if uniform(0, 1) <= intensity else 0)

class DataSynchronizer(Mechanism):
    '''The data synchronizer combines the raw data from the logs and
    the detector outputs, putting them into dictionaries of
    corresponding data.

    '''

    def __init__(self, logS, logL, logR,
                 detectedL1, detectedL2,
                 detectedR1, detectedR2,
                 dataout):
        Mechanism.__init__(self)
        self.logS = logS
        self.logL = logL
        self.logR = logR
        self.detectedL1 = detectedL1
        self.detectedL2 = detectedL2
        self.detectedR1 = detectedR1
        self.detectedR2 = detectedR2
        self.dataout = dataout

    def run(self):
        '''This method does the synchronizing.'''
        self.dataout.put({"logS" : self.logS.get(),
                          "logL" : self.logL.get(),
                          "logR" : self.logR.get(),
                          "detectedL1" : self.detectedL1.get(),
                          "detectedL2" : self.detectedL2.get(),
                          "detectedR1" : self.detectedR1.get(),
                          "detectedR2" : self.detectedR2.get()})

def save_raw_data(filename, data):
    def save_data(f):
        f.write(str(len(data)))
        f.write("\n")
        for entry in data:
            f.write(str(entry["logS"]))
            f.write(" ")
            f.write(str(entry["logL"]))
            f.write(" ")
            f.write(str(entry["logR"]))
            f.write(" ")
            f.write(str(entry["detectedL1"]))
            f.write(" ")
            f.write(str(entry["detectedL2"]))
            f.write(" ")
            f.write(str(entry["detectedR1"]))
            f.write(" ")
            f.write(str(entry["detectedR2"]))
            f.write("\n")
    if filename != "-":
        with open(filename, "w") as f:
            save_data(f)
    else:
        save_data(sys.stdout)

if __name__ == '__main__':

    if len(sys.argv) != 2 and len(sys.argv) != 3:
        print("Usage: " + sys.argv[0] + " NUM_PULSES [RAW_DATA_FILE]")
        sys.exit(1)
    num_pulses = int(sys.argv[1])
    raw_data_filename = (sys.argv[2] if len(sys.argv) == 3 else "-")

    seed()             # Initialize random numbers with a random seed.

    # Angles commonly used in actual experiments. Whatever angles you
    # use have to be zero degrees or placed in Quadrant 1. This
    # constraint comes with no loss of generality, because a
    # polarizing beam splitter is actually a sort of rotated
    # "X". Therefore its orientation can be specified by any one of
    # the arms of the X. Using the Quadrant 1 arm simplifies data
    # analysis.
    anglesL = (0.0, 45.0)
    anglesR = (22.5, 67.5)
    assert (all(0 <= x and x < 90 for x in anglesL + anglesR))

    # Queues used for communications between the processes. (Note that
    # the direction of communication is always forwards in time. This
    # forwards-in-time behavior is guaranteed by using queues for the
    # communications, instead of Python's two-way pipes.)
    max_size = 100000
    logS = mp.Queue(max_size)
    logL = mp.Queue(max_size)
    logR = mp.Queue(max_size)
    L = mp.Queue(max_size)
    R = mp.Queue(max_size)
    L1 = mp.Queue(max_size)
    L2 = mp.Queue(max_size)
    R1 = mp.Queue(max_size)
    R2 = mp.Queue(max_size)
    detectedL1 = mp.Queue(max_size)
    detectedL2 = mp.Queue(max_size)
    detectedR1 = mp.Queue(max_size)
    detectedR2 = mp.Queue(max_size)
    dataout = mp.Queue(max_size)

    # Objects that will run in the various processes.
    lightsource = LightSource(L, R, logS)
    splitterL = PolarizingBeamSplitter(L, L1, L2, logL, anglesL)
    splitterR = PolarizingBeamSplitter(R, R1, R2, logR, anglesR)
    detectorL1 = LightDetector(L1, detectedL1)
    detectorL2 = LightDetector(L2, detectedL2)
    detectorR1 = LightDetector(R1, detectedR1)
    detectorR2 = LightDetector(R2, detectedR2)
    sync = DataSynchronizer(logS, logL, logR, detectedL1, detectedL2,
                            detectedR1, detectedR2, dataout)

    # Processes.
    lightsource_process = mp.Process(target=lightsource)
    splitterL_process = mp.Process(target=splitterL)
    splitterR_process = mp.Process(target=splitterR)
    detectorL1_process = mp.Process(target=detectorL1)
    detectorL2_process = mp.Process(target=detectorL2)
    detectorR1_process = mp.Process(target=detectorR1)
    detectorR2_process = mp.Process(target=detectorR2)
    sync_process = mp.Process(target=sync)

    # Start the processes.
    sync_process.start()
    detectorL1_process.start()
    detectorL2_process.start()
    detectorR1_process.start()
    detectorR2_process.start()
    splitterL_process.start()
    splitterR_process.start()
    lightsource_process.start()

    data = []
    for i in range(num_pulses):
        data.append(dataout.get())
    save_raw_data(raw_data_filename, data)

    # Shut down the apparatus.
    logS.close()
    logL.close()
    logR.close()
    L.close()
    R.close()
    L1.close()
    L2.close()
    R1.close()
    R2.close()
    detectedL1.close()
    detectedL2.close()
    detectedR1.close()
    detectedR2.close()
    dataout.close()
    lightsource_process.terminate()
    splitterL_process.terminate()
    splitterR_process.terminate()
    detectorL1_process.terminate()
    detectorL2_process.terminate()
    detectorR1_process.terminate()
    detectorR2_process.terminate()
    sync_process.terminate()
