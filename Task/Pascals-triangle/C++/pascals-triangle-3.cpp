// Compile with -std=c++11
#include<iostream>
#include<vector>
using namespace std;
class pascal_triangle{
	vector<vector<int>> data; // This is the actual data
	void print_row(vector<int> dummy){
		for (vector<int>::iterator i = dummy.begin(); i != dummy.end(); ++i)
			cout<<*i<<" ";
		cout<<endl;
	}
public:
	pascal_triangle(int dummy){ // Everything is done on the construction phase
		if (dummy > 0){ // if the argument is 0 or negative exit immediately
			vector<int> row;
			data.resize(dummy); // Theoretically this should work faster than consecutive push_back()s
			// The first row
			row.resize(1);
			row.at(0) = 1;
			data.at(0) = row;
			// The second row
			if (data.size() > 1){
				row.resize(2);
				row.at(0) = 1; row.at(1) = 1;
				data.at(1) = row;
			}
			// The other rows
			if (data.size() > 2){
				for (int i = 2; i < data.size(); i++){
					row.resize(i + 1); // Theoretically this should work faster than consecutive push_back()s
					row.front() = 1;
					for (int j = 1; j < row.size() - 1; j++)
						row.at(j) = data.at(i - 1).at(j - 1) + data.at(i - 1).at(j);
					row.back() = 1;
					data.at(i) = row;
				}
			}
		}
	}
	~pascal_triangle(){
		for (vector<vector<int>>::iterator i = data.begin(); i != data.end(); ++i)
			i->clear(); // I'm not sure about the necessity of this loop!
		data.clear();
	}
	void print_row(int dummy){
		if (dummy < data.size())
			for (vector<int>::iterator i = data.at(dummy).begin(); i != data.at(dummy).end(); ++i)
				cout<<*i<<" ";
		cout<<endl;
	}
	void print(){
		for (int i = 0; i < data.size(); i++)
			print_row(i);
	}
	int get_coeff(int dummy1, int dummy2){
		int result = 0;
		if ((dummy1 < data.size()) && (dummy2 < data.at(dummy1).size()))
				result = data.at(dummy1).at(dummy2);
		return result;
	}
	vector<int> get_row(int dummy){
		vector<int> result;
		if (dummy < data.size())
			result = data.at(dummy);
		return result;
	}
};
int main(){
	int n;
	cout<<endl<<"The Pascal's Triangle with a class!"<<endl<<endl<<"Enter the number of rows: ";
	cin>>n;
	pascal_triangle myptri(n);
	cout<<endl<<"The whole triangle:"<<endl;
	myptri.print();
	cout<<endl<<"Just one row:"<<endl;
	myptri.print_row(n/2);
	cout<<endl<<"Just one coefficient:"<<endl;
	cout<<myptri.get_coeff(n/2, n/4)<<endl<<endl;
	return 0;
}
