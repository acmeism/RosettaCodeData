#!/usr/bin/python
# coding=UTF-8
from __future__ import print_function

def printCircuit(adj):

    # adj represents the adjacency list of
    # the directed graph
    # edge_count represents the number of edges
    # emerging from a vertex
    edge_count = dict()

    for i in range(len(adj)):

        # find the count of edges to keep track
        # of unused edges
        edge_count[i] = len(adj[i])

    if len(adj) == 0:
        return # empty graph

    # Maintain a stack to keep vertices
    curr_path = []

    # vector to store final circuit
    circuit = []

    # start from any vertex
    curr_path.append(0)
    curr_v = 0 # Current vertex

    while len(curr_path):

        # If there's remaining edge
        if edge_count[curr_v]:

            # Push the vertex
            curr_path.append(curr_v)

            # Find the next vertex using an edge
            next_v = adj[curr_v][-1]

            # and remove that edge
            edge_count[curr_v] -= 1
            adj[curr_v].pop()

            # Move to next vertex
            curr_v = next_v

        # back-track to find remaining circuit
        else:
            circuit.append(curr_v)

            # Back-tracking
            curr_v = curr_path[-1]
            curr_path.pop()

    # we've got the circuit, now print it in reverse
    for i in range(len(circuit) - 1, -1, -1):
        print(circuit[i], end = "")
        if i:
            print(" -> ", end = "")

# Driver Code
if __name__ == "__main__":

    # Input Graph 1
    adj1 = [0] * 3
    for i in range(3):
        adj1[i] = []

    # Build the edges
    adj1[0].append(1)
    adj1[1].append(2)
    adj1[2].append(0)
    printCircuit(adj1)
    print()

    # Input Graph 2
    adj2 = [0] * 7
    for i in range(7):
        adj2[i] = []

    adj2[0].append(1)
    adj2[0].append(6)
    adj2[1].append(2)
    adj2[2].append(0)
    adj2[2].append(3)
    adj2[3].append(4)
    adj2[4].append(2)
    adj2[4].append(5)
    adj2[5].append(0)
    adj2[6].append(4)
    printCircuit(adj2)
    print()
