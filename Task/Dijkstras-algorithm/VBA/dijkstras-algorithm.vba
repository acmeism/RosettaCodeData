Class Branch
Public from As Node '[according to Dijkstra the first Node should be closest to P]
Public towards As Node
Public length As Integer '[directed length!]
Public distance As Integer '[from P to farthest node]
Public key As String
Class Node
Public key As String
Public correspondingBranch As Branch
Const INFINITY = 32767
Private Sub Dijkstra(Nodes As Collection, Branches As Collection, P As Node, Optional Q As Node)
    'Dijkstra, E. W. (1959). "A note on two problems in connexion with graphs".
    'Numerische Mathematik. 1: 269–271. doi:10.1007/BF01386390.
    'http://www-m3.ma.tum.de/twiki/pub/MN0506/WebHome/dijkstra.pdf
    'Problem 2. Find the path of minimum total length between two given nodes
    'P and Q.
    'We use the fact that, if R is a node on the minimal path from P to Q, knowledge
    'of the latter implies the knowledge of the minimal path from P to A. In the
    'solution presented, the minimal paths from P to the other nodes are constructed
    'in order of increasing length until Q is reached.
    'In the course of the solution the nodes are subdivided into three sets:
    'A. the nodes for which the path of minimum length from P is known; nodes
    'will be added to this set in order of increasing minimum path length from node P;
    '[comments in square brackets are not by Dijkstra]
    Dim a As New Collection '[of nodes (vertices)]
    'B. the nodes from which the next node to be added to set A will be selected;
    'this set comprises all those nodes that are connected to at least one node of
    'set A but do not yet belong to A themselves;
    Dim b As New Collection '[of nodes (vertices)]
    'C. the remaining nodes.
    Dim c As New Collection '[of nodes (vertices)]
    'The Branches are also subdivided into three sets:
    'I the Branches occurring in the minimal paths from node P to the nodes
    'in set A;
    Dim I As New Collection '[of Branches (edges)]
    'II the Branches from which the next branch to be placed in set I will be
    'selected; one and only one branch of this set will lead to each node in set B;
    Dim II As New Collection '[of Branches (edges)]
    'III. the remaining Branches (rejected or not yet considered).
    Dim III As New Collection '[of Branches (edges)]
    Dim u As Node, R_ As Node, dist As Integer
    'To start with, all nodes are in set C and all Branches are in set III. We now
    'transfer node P to set A and from then onwards repeatedly perform the following
    'steps.
    For Each n In Nodes
        c.Add n, n.key
    Next n
    For Each e In Branches
        III.Add e, e.key
    Next e
    a.Add P, P.key
    c.Remove P.key
    Set u = P
    Do
        'Step 1. Consider all Branches r connecting the node just transferred to set A
        'with nodes R in sets B or C. If node R belongs to set B, we investigate whether
        'the use of branch r gives rise to a shorter path from P to R than the known
        'path that uses the corresponding branch in set II. If this is not so, branch r is
        'rejected; if, however, use of branch r results in a shorter connexion between P
        'and R than hitherto obtained, it replaces the corresponding branch in set II
        'and the latter is rejected. If the node R belongs to set C, it is added to set B and
        'branch r is added to set II.
        For Each r In III
            If r.from Is u Then
                Set R_ = r.towards
                If Belongs(R_, c) Then
                    c.Remove R_.key
                    b.Add R_, R_.key
                    Set R_.correspondingBranch = r
                    If u.correspondingBranch Is Nothing Then
                        R_.correspondingBranch.distance = r.length
                    Else
                        R_.correspondingBranch.distance = u.correspondingBranch.distance + r.length
                    End If
                    III.Remove r.key '[not mentioned by Dijkstra ...]
                    II.Add r, r.key
                Else
                    If Belongs(R_, b) Then '[initially B is empty ...]
                        If R_.correspondingBranch.distance > u.correspondingBranch.distance + r.length Then
                            II.Remove R_.correspondingBranch.key
                            II.Add r, r.key
                            Set R_.correspondingBranch = r '[needed in step 2.]
                            R_.correspondingBranch.distance = u.correspondingBranch.distance + r.length
                        End If
                    End If
                End If
            End If
        Next r
        'Step 2. Every node in set B can be connected to node P in only one way
        'if we restrict ourselves to Branches from set I and one from set II. In this sense
        'each node in set B has a distance from node P: the node with minimum distance
        'from P is transferred from set B to set A, and the corresponding branch is transferred
        'from set II to set I. We then return to step I and repeat the process
        'until node Q is transferred to set A. Then the solution has been found.
        dist = INFINITY
        Set u = Nothing
        For Each n In b
            If dist > n.correspondingBranch.distance Then
                dist = n.correspondingBranch.distance
                Set u = n
            End If
        Next n
        b.Remove u.key
        a.Add u, u.key
        II.Remove u.correspondingBranch.key
        I.Add u.correspondingBranch, u.correspondingBranch.key
    Loop Until IIf(Q Is Nothing, a.Count = Nodes.Count, u Is Q)
    If Not Q Is Nothing Then GetPath Q
End Sub
Private Function Belongs(n As Node, col As Collection) As Boolean
    Dim obj As Node
    On Error GoTo err
        Belongs = True
        Set obj = col(n.key)
        Exit Function
err:
        Belongs = False
End Function
Private Sub GetPath(Target As Node)
    Dim path As String
    If Target.correspondingBranch Is Nothing Then
        path = "no path"
    Else
        path = Target.key
        Set u = Target
        Do While Not u.correspondingBranch Is Nothing
            path = u.correspondingBranch.from.key & " " & path
            Set u = u.correspondingBranch.from
        Loop
        Debug.Print u.key, Target.key, Target.correspondingBranch.distance, path
    End If
End Sub
Public Sub test()
    Dim a As New Node, b As New Node, c As New Node, d As New Node, e As New Node, f As New Node
    Dim ab As New Branch, ac As New Branch, af As New Branch, bc As New Branch, bd As New Branch
    Dim cd As New Branch, cf As New Branch, de As New Branch, ef As New Branch
    Set ab.from = a: Set ab.towards = b: ab.length = 7: ab.key = "ab": ab.distance = INFINITY
    Set ac.from = a: Set ac.towards = c: ac.length = 9: ac.key = "ac": ac.distance = INFINITY
    Set af.from = a: Set af.towards = f: af.length = 14: af.key = "af": af.distance = INFINITY
    Set bc.from = b: Set bc.towards = c: bc.length = 10: bc.key = "bc": bc.distance = INFINITY
    Set bd.from = b: Set bd.towards = d: bd.length = 15: bd.key = "bd": bd.distance = INFINITY
    Set cd.from = c: Set cd.towards = d: cd.length = 11: cd.key = "cd": cd.distance = INFINITY
    Set cf.from = c: Set cf.towards = f: cf.length = 2: cf.key = "cf": cf.distance = INFINITY
    Set de.from = d: Set de.towards = e: de.length = 6: de.key = "de": de.distance = INFINITY
    Set ef.from = e: Set ef.towards = f: ef.length = 9: ef.key = "ef": ef.distance = INFINITY
    a.key = "a"
    b.key = "b"
    c.key = "c"
    d.key = "d"
    e.key = "e"
    f.key = "f"
    Dim testNodes As New Collection
    Dim testBranches As New Collection
    testNodes.Add a, "a"
    testNodes.Add b, "b"
    testNodes.Add c, "c"
    testNodes.Add d, "d"
    testNodes.Add e, "e"
    testNodes.Add f, "f"
    testBranches.Add ab, "ab"
    testBranches.Add ac, "ac"
    testBranches.Add af, "af"
    testBranches.Add bc, "bc"
    testBranches.Add bd, "bd"
    testBranches.Add cd, "cd"
    testBranches.Add cf, "cf"
    testBranches.Add de, "de"
    testBranches.Add ef, "ef"
    Debug.Print "From", "To", "Distance", "Path"
    '[Call Dijkstra with target:]
    Dijkstra testNodes, testBranches, a, e
    '[Call Dijkstra without target computes paths to all reachable nodes:]
    Dijkstra testNodes, testBranches, a
    GetPath f
End Sub
