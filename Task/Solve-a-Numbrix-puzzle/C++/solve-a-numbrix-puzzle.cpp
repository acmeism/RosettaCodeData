#include <vector>
#include <sstream>
#include <iostream>
#include <iterator>
#include <cstdlib>
#include <string>
#include <bitset>

using namespace std;
typedef bitset<4> hood_t;

struct node
{
	int val;
	hood_t neighbors;
};

class nSolver
{
public:

	void solve(vector<string>& puzz, int max_wid)
	{
		if (puzz.size() < 1) return;
		wid = max_wid;
		hei = static_cast<int>(puzz.size()) / wid;
		max = wid * hei;
		int len = max, c = 0;
		arr = vector<node>(len, node({ 0, 0 }));
		weHave = vector<bool>(len + 1, false);

		for (const auto& s : puzz)
		{
			if (s == "*") { max--; arr[c++].val = -1; continue; }
			arr[c].val = atoi(s.c_str());
			if (arr[c].val > 0) weHave[arr[c].val] = true;
			c++;
		}

		solveIt(); c = 0;
		for (auto&& s : puzz)
		{
			if (s == ".")
				s = std::to_string(arr[c].val);
			c++;
		}
	}

private:
	bool search(int x, int y, int w, int dr)
	{
		if ((w > max && dr > 0) || (w < 1 && dr < 0) || (w == max && weHave[w])) return true;

		node& n = arr[x + y * wid];
		n.neighbors = getNeighbors(x, y);
		if (weHave[w])
		{
			for (int d = 0; d < 4; d++)
			{
				if (n.neighbors[d])
				{
					int a = x + dx[d], b = y + dy[d];
					if (arr[a + b * wid].val == w)
						if (search(a, b, w + dr, dr))
							return true;
				}
			}
			return false;
		}

		for (int d = 0; d < 4; d++)
		{
			if (n.neighbors[d])
			{
				int a = x + dx[d], b = y + dy[d];
				if (arr[a + b * wid].val == 0)
				{
					arr[a + b * wid].val = w;
					if (search(a, b, w + dr, dr))
						return true;
					arr[a + b * wid].val = 0;
				}
			}
		}
		return false;
	}

	hood_t getNeighbors(int x, int y)
	{
		hood_t retval;
		for (int xx = 0; xx < 4; xx++)
		{
			int a = x + dx[xx], b = y + dy[xx];
			if (a < 0 || b < 0 || a >= wid || b >= hei)
				continue;
			if (arr[a + b * wid].val > -1)
				retval.set(xx);
		}
		return retval;
	}

	void solveIt()
	{
		int x, y, z; findStart(x, y, z);
		if (z == 99999) { cout << "\nCan't find start point!\n"; return; }
		search(x, y, z + 1, 1);
		if (z > 1) search(x, y, z - 1, -1);
	}

	void findStart(int& x, int& y, int& z)
	{
		z = 99999;
		for (int b = 0; b < hei; b++)
		for (int a = 0; a < wid; a++)
		if (arr[a + wid * b].val > 0 && arr[a + wid * b].val < z)
		{
			x = a; y = b;
			z = arr[a + wid * b].val;
		}

	}

	vector<int> dx = vector<int>({ -1, 1, 0, 0 });
	vector<int> dy = vector<int>({ 0, 0, -1, 1 });
	int wid, hei, max;
	vector<node> arr;
	vector<bool> weHave;
};

//------------------------------------------------------------------------------
int main(int argc, char* argv[])
{
	int wid; string p;
	//p = ". . . . . . . . . . . 46 45 . 55 74 . . . 38 . . 43 . . 78 . . 35 . . . . . 71 . . . 33 . . . 59 . . . 17 . . . . . 67 . . 18 . . 11 . . 64 . . . 24 21 . 1  2 . . . . . . . . . . ."; wid = 9;
	//p = ". . . . . . . . . . 11 12 15 18 21 62 61 . .  6 . . . . . 60 . . 33 . . . . . 57 . . 32 . . . . . 56 . . 37 .  1 . . . 73 . . 38 . . . . . 72 . . 43 44 47 48 51 76 77 . . . . . . . . . ."; wid = 9;
	p = "17 . . . 11 . . . 59 . 15 . . 6 . . 61 . . . 3 . . .  63 . . . . . . 66 . . . . 23 24 . 68 67 78 . 54 55 . . . . 72 . . . . . . 35 . . . 49 . . . 29 . . 40 . . 47 . 31 . . . 39 . . . 45"; wid = 9;

	istringstream iss(p); vector<string> puzz;
	copy(istream_iterator<string>(iss), istream_iterator<string>(), back_inserter<vector<string> >(puzz));
	nSolver s; s.solve(puzz, wid);

	int c = 0;
	for (const auto& s : puzz)
	{
		if (s != "*" && s != ".")
		{
			if (atoi(s.c_str()) < 10) cout << "0";
			cout << s << " ";
		}
		else cout << "   ";
		if (++c >= wid) { cout << endl; c = 0; }
	}
	cout << endl << endl;
	return system("pause");
}
