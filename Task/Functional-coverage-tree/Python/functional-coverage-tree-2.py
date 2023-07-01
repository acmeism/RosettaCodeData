# -*- coding: utf-8 -*-

SPACES = 4
class Node:
    path2node = {}

    def add_node(self, pathname, wt, cov):
        path2node = self.path2node
        path, name = pathname.strip().rsplit('/', 1)
        node = Node(name, wt, cov)
        path2node[pathname] = node
        path2node[path].child.append(node) # Link the tree

    def __init__(self, name="", wt=1, cov=0.0, child=None):
        if child is None:
            child = []
        self.name, self.wt, self.cov, self.child = name, wt, cov, child
        self.delta = None
        self.sum_wt = wt
        if name == "":
            # designate the top of the tree
            self.path2node[name] = self


    def __repr__(self, indent=0):
        name, wt, cov, delta, child = (self.name, self.wt, self.cov,
                                       self.delta, self.child)
        lhs = ' ' * (SPACES * indent) + "Node(%r," % name
        txt = '%-40s wt=%2g, cov=%-8.5g, delta=%-10s, child=[' \
              % (lhs, wt, cov, ('n/a' if delta is None else '%-10.7f' % delta))
        if not child:
            txt += (']),\n')
        else:
            txt += ('\n')
            for c in child:
                txt += c.__repr__(indent + 1)
            txt += (' ' * (SPACES * indent) + "]),\n")
        return txt

    def covercalc(self):
        '''
        Depth first weighted average of coverage
        '''
        child = self.child
        if not child:
            return self.cov
        sum_covwt, sum_wt = 0, 0
        for node in child:
            nwt = node.wt
            ncov = node.covercalc()
            sum_wt += nwt
            sum_covwt += ncov * nwt
        cov = sum_covwt / sum_wt
        self.sum_wt = sum_wt
        self.cov = cov
        return cov

    def deltacalc(self, power=1.0):
        '''
        Top down distribution of weighted residuals
        '''
        sum_wt = self.sum_wt
        self.delta = delta = (1 - self.cov) * power
        for node in self.child:
            node.deltacalc(power * node.wt / sum_wt)
        return delta


def isclose(a, b, rel_tol=1e-9, abs_tol=1e-9):
    return abs(a-b) <= max( rel_tol * max(abs(a), abs(b)), abs_tol )


if __name__ == '__main__':
    top = Node()    # Add placeholder for top of tree
    add_node = top.add_node

    add_node('/cleaning', 1, 0)
    add_node('/cleaning/house1', 40, 0)
    add_node('/cleaning/house1/bedrooms', 1, 0.25)
    add_node('/cleaning/house1/bathrooms', 1, 0)
    add_node('/cleaning/house1/bathrooms/bathroom1', 1, 0.5)
    add_node('/cleaning/house1/bathrooms/bathroom2', 1, 0)
    add_node('/cleaning/house1/bathrooms/outside_lavatory', 1, 1)
    add_node('/cleaning/house1/attic', 1, 0.75)
    add_node('/cleaning/house1/kitchen', 1, 0.1)
    add_node('/cleaning/house1/living_rooms', 1, 0)
    add_node('/cleaning/house1/living_rooms/lounge', 1, 0)
    add_node('/cleaning/house1/living_rooms/dining_room', 1, 0)
    add_node('/cleaning/house1/living_rooms/conservatory', 1, 0)
    add_node('/cleaning/house1/living_rooms/playroom', 1, 1)
    add_node('/cleaning/house1/basement', 1, 0)
    add_node('/cleaning/house1/garage', 1, 0)
    add_node('/cleaning/house1/garden', 1, 0.8)
    add_node('/cleaning/house2', 60, 0)
    add_node('/cleaning/house2/upstairs', 1, 0)
    add_node('/cleaning/house2/upstairs/bedrooms', 1, 0)
    add_node('/cleaning/house2/upstairs/bedrooms/suite_1', 1, 0)
    add_node('/cleaning/house2/upstairs/bedrooms/suite_2', 1, 0)
    add_node('/cleaning/house2/upstairs/bedrooms/bedroom_3', 1, 0)
    add_node('/cleaning/house2/upstairs/bedrooms/bedroom_4', 1, 0)
    add_node('/cleaning/house2/upstairs/bathroom', 1, 0)
    add_node('/cleaning/house2/upstairs/toilet', 1, 0)
    add_node('/cleaning/house2/upstairs/attics', 1, 0.6)
    add_node('/cleaning/house2/groundfloor', 1, 0)
    add_node('/cleaning/house2/groundfloor/kitchen', 1, 0)
    add_node('/cleaning/house2/groundfloor/living_rooms', 1, 0)
    add_node('/cleaning/house2/groundfloor/living_rooms/lounge', 1, 0)
    add_node('/cleaning/house2/groundfloor/living_rooms/dining_room', 1, 0)
    add_node('/cleaning/house2/groundfloor/living_rooms/conservatory', 1, 0)
    add_node('/cleaning/house2/groundfloor/living_rooms/playroom', 1, 0)
    add_node('/cleaning/house2/groundfloor/wet_room_&_toilet', 1, 0)
    add_node('/cleaning/house2/groundfloor/garage', 1, 0)
    add_node('/cleaning/house2/groundfloor/garden', 1, 0.9)
    add_node('/cleaning/house2/groundfloor/hot_tub_suite', 1, 1)
    add_node('/cleaning/house2/basement', 1, 0)
    add_node('/cleaning/house2/basement/cellars', 1, 1)
    add_node('/cleaning/house2/basement/wine_cellar', 1, 1)
    add_node('/cleaning/house2/basement/cinema', 1, 0.75)

    top = top.child[0]  # Remove artificial top
    cover = top.covercalc()
    delta = top.deltacalc()
    print('TOP COVERAGE = %g\n' % cover)
    print(top)
    assert isclose((delta + cover), 1.0), "Top level delta + coverage should " \
                                          "equal 1 instead of (%f + %f)" % (delta, cover)
