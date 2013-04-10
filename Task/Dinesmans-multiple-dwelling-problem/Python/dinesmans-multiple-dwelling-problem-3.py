from amb import Amb

if __name__ == '__main__':
    amb = Amb()

    maxfloors = 5
    floors = range(1, maxfloors+1)
    # Possible floors for each person
    Baker, Cooper, Fletcher, Miller, Smith = (amb(floors) for i in range(5))
    for _dummy in amb( lambda Baker, Cooper, Fletcher, Miller, Smith: (
                         len(set([Baker, Cooper, Fletcher, Miller, Smith])) == 5  # each to a separate floor
                         and Baker != maxfloors
                         and Cooper != 1
                         and Fletcher not in (maxfloors, 1)
                         and Miller > Cooper
                         and (Smith - Fletcher) not in (1, -1)  # Not adjacent
                         and (Fletcher - Cooper) not in (1, -1) # Not adjacent
                         ) ):

        print 'Floors are numbered from 1 to %i inclusive.' % maxfloors
        print '\n'.join(sorted('  Floor %i is occupied by %s'
                                   % (globals()[name], name)
                               for name in 'Baker, Cooper, Fletcher, Miller, Smith'.split(', ')))
        break
    else:
        print 'No solution found.'
    print


    print '# Add another person with more constraints and more floors:'
    # The order that Guinan is added to any list of people must stay consistant

    amb = Amb()

    maxfloors = 7
    floors = range(1, maxfloors+1)
    # Possible floors for each person
    Baker, Cooper, Fletcher, Miller, Guinan, Smith = (amb(floors) for i in range(6))
    for _dummy in amb( lambda Baker, Cooper, Fletcher, Miller, Guinan, Smith: (
                         len(set([Baker, Cooper, Fletcher, Miller, Guinan, Smith])) == 6  # each to a separate floor
                         and Guinan not in (maxfloors, 3, 4)
                         and Baker != maxfloors
                         and Cooper != 1
                         and Fletcher not in (maxfloors, 1)
                         and Miller > Cooper
                         and (Smith - Fletcher) not in (1, -1)  # Not adjacent
                         and (Fletcher - Cooper) not in (1, -1) # Not adjacent
                         ) ):

        print 'Floors are numbered from 1 to %i inclusive.' % maxfloors
        print '\n'.join(sorted('  Floor %i is occupied by %s'
                                   % (globals()[name], name)
                               for name in 'Baker, Cooper, Fletcher, Miller, Guinan, Smith'.split(', ')))
        break
    else:
        print 'No solution found.'
    print
