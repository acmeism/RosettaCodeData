// Compilation command: g++ -std=c++20 -Wall -Wextra -pedantic SchieberVishkinAlgorithm.cpp -o SchieberVishkinAlgorithm

#include <algorithm>
#include <array>
#include <bit>
#include <cassert>
#include <iostream>
#include <limits>
#include <span>
#include <stack>
#include <vector>

struct Node {
    int child = 0;
    int sibling = 0;
    int parent = 0;
};

struct LCAData {
    std::vector<int> pi;
    std::vector<int> beta;
    std::vector<int> alpha;
    std::vector<int> tau;
    std::vector<int> lambda;
};

bool traversalPhase(
    int &p, int &time,
    std::vector<int> &pi,
    std::vector<int> &beta,
    std::vector<int> &tau,
    std::vector<int> &lambda,
    const std::vector<Node> &nodes
) {
    while (true) {
        ++time;
        pi[p] = time;
        tau[time] = 0;
        lambda[time] = 1 + lambda[time>>1];
        if (nodes[p].child != 0) {
            p = nodes[p].child;
            continue;
        }
        beta[p] = time;
        break;
    }
    while (true) {
        tau[beta[p]] = nodes[p].parent;
        if (nodes[p].sibling != 0) {
            p = nodes[p].sibling;
            return true;
        }
        p = nodes[p].parent;
        if (p != 0) {
            int w = time & -pi[p];
            int h = lambda[w];
            beta[p] = ((time >> h) | 1) << h;
        } else
            return false;
    }
}

void computeAlpha(
    const std::vector<Node> &nodes,
    int root,
    std::vector<int> &alpha,
    const std::vector<int> &beta
) {
    std::stack<int> stk;
    stk.push(root);
    while (!stk.empty()) {
        int u = stk.top(); stk.pop();
        alpha[u] = alpha[nodes[u].parent] | (beta[u] & -beta[u]);
        if (nodes[u].sibling)
            stk.push(nodes[u].sibling);
        if (nodes[u].child)
            stk.push(nodes[u].child);
    }
}

LCAData buildLCAData(int N, const std::vector<int>& A) {
    LCAData D;
    D.pi.assign(N+1, 0);
    D.beta.assign(N+1, 0);
    D.alpha.assign(N+1, 0);
    D.tau.assign(N+1, 0);
    D.lambda.assign(N+1, 0);

    std::vector<Node> nodes(N + 1);
    int t = 0;
    for (int v = N; v > 0; --v) {
        int u = 0;
        while (A[v] > A[t] || (A[v] == A[t] && v > t)) {
            u = t;
            t = nodes[t].parent;
        }
        if (u) {
            nodes[v].sibling = nodes[u].sibling;
            nodes[u].sibling = 0;
            nodes[u].parent = v;
            nodes[v].child = u;
        } else
            nodes[v].sibling = nodes[t].child;
        nodes[t].child = v;
        nodes[v].parent = t;
        t = v;
    }

    int p = nodes[0].child;
    int time = 0;
    D.lambda[0] = -1;
    while (traversalPhase(p, time, D.pi, D.beta, D.tau, D.lambda, nodes));

    p = nodes[0].child;
    D.lambda[0] = D.lambda[time];
    D.pi[0] = D.beta[0] = D.alpha[0] = 0;
    if (p)
        computeAlpha(nodes, p, D.alpha, D.beta);
    return D;
}

int nca(int x, int y, const LCAData& D) {
    unsigned bx = static_cast<unsigned>(D.beta[x]);
    unsigned by = static_cast<unsigned>(D.beta[y]);
    unsigned b = (bx <= by) ? (by & -bx) : (bx & -by);
    if (b == 0)
        return D.pi[x] <= D.pi[y] ? x : y;
    int h = std::countr_zero(b);

    unsigned ax = static_cast<unsigned>(D.alpha[x]);
    unsigned ay = static_cast<unsigned>(D.alpha[y]);
    unsigned k = ax & ay & ~((~0u) << h);
    if (k == 0)
        return D.pi[x] <= D.pi[y] ? x : y;
    h = std::countr_zero(k);

    int jx = (((D.beta[x] >> h) | 1) << h);
    if (jx != D.beta[x]) {
        unsigned lmask = static_cast<unsigned>(D.alpha[x]) & ((1u << h) - 1u);
        if (lmask) {
            int l = std::countr_zero(lmask);
            x = D.tau[(((D.beta[x] >> l) | 1) << l)];
        }
    }
    int jy = (((D.beta[y] >> h) | 1) << h);
    if (jy != D.beta[y]) {
        unsigned lmask = static_cast<unsigned>(D.alpha[y]) & ((1u << h) - 1u);
        if (lmask) {
            int l = std::countr_zero(lmask);
            y = D.tau[(((D.beta[y] >> l) | 1) << l)];
        }
    }
    return D.pi[x] <= D.pi[y] ? x : y;
}

std::vector<int> solveTestCase(
    const std::vector<int> &values,
    const std::vector<std::array<int, 2>> &queries
) {
    int n = int(values.size());
    std::vector<int> A(n+2), R(n+2), B(n+2);
    A[0] = std::numeric_limits<int>::max();
    int N = 1, cnt = 0;
    for (int i = 1; i <= n; ++i) {
        if (i > 1 && values[i-1] != values[i-2]) {
            A[N] = cnt;
            R[N] = i;
            ++N;
            cnt = 0;
        }
        B[i] = N;
        ++cnt;
    }
    A[N] = cnt;
    R[N] = n + 1;

    LCAData D = buildLCAData(N, A);
    std::vector<int> ans;
    ans.reserve(queries.size());
    for (auto [i, j] : queries) {
        int x = B[i], y = B[j];
        int z;
        if (x == y)
            z = j - i + 1;
        else {
            int mid = (x + 1 < y) ? A[nca(x+1, y-1, D)] : 0;
            z = std::max({mid, R[x]-i, A[y]-(R[y]-j)+1});
        }
        ans.push_back(z);
    }
    return ans;
}

int main() {
    std::vector<int> values = {-1, -1, 1, 1, 1, 1, 3, 10, 10, 10};
    std::vector<std::array<int, 2>> queries = {{2, 3}, {1, 10}, {5, 10}};
    std::vector<int> expected = {1, 4, 3};
    auto result = solveTestCase(values, queries);
    assert(result == expected);
    std::cout << "All tests passed.\n";
    return 0;
}
