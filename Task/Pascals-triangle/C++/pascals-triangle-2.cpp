// Compile with -std=c++11
#include<iostream>
#include<vector>
using namespace std;
void print_vector(vector<int> dummy){
	for (vector<int>::iterator i = dummy.begin(); i != dummy.end(); ++i)
		cout<<*i<<" ";
	cout<<endl;
}
void print_vector_of_vectors(vector<vector<int>> dummy){
	for (vector<vector<int>>::iterator i = dummy.begin(); i != dummy.end(); ++i)
		print_vector(*i);
	cout<<endl;
}
vector<vector<int>> dynamic_triangle(int dummy){
	vector<vector<int>> result;
	if (dummy > 0){ // if the argument is 0 or negative exit immediately
		vector<int> row;
		// The first row
		row.push_back(1);
		result.push_back(row);
		// The second row
		if (dummy > 1){
			row.clear();
			row.push_back(1); row.push_back(1);
			result.push_back(row);
		}
		// The other rows
		if (dummy > 2){
			for (int i = 2; i < dummy; i++){
				row.clear();
				row.push_back(1);
				for (int j = 1; j < i; j++)
					row.push_back(result.back().at(j - 1) + result.back().at(j));
				row.push_back(1);
				result.push_back(row);
			}
		}
	}
	return result;
}
vector<vector<int>> static_triangle(int dummy){
	vector<vector<int>> result;
	if (dummy > 0){ // if the argument is 0 or negative exit immediately
		vector<int> row;
		result.resize(dummy); // This should work faster than consecutive push_back()s
		// The first row
		row.resize(1);
		row.at(0) = 1;
		result.at(0) = row;
		// The second row
		if (result.size() > 1){
			row.resize(2);
			row.at(0) = 1; row.at(1) = 1;
			result.at(1) = row;
		}
		// The other rows
		if (result.size() > 2){
			for (int i = 2; i < result.size(); i++){
				row.resize(i + 1); // This should work faster than consecutive push_back()s
				row.front() = 1;
				for (int j = 1; j < row.size() - 1; j++)
					row.at(j) = result.at(i - 1).at(j - 1) + result.at(i - 1).at(j);
				row.back() = 1;
				result.at(i) = row;
			}
		}
	}
	return result;
}
int main(){
	vector<vector<int>> triangle;
	int n;
	cout<<endl<<"The Pascal's Triangle"<<endl<<"Enter the number of rows: ";
	cin>>n;
	// Call the dynamic function
	triangle = dynamic_triangle(n);
	cout<<endl<<"Calculated using dynamic vectors:"<<endl<<endl;
	print_vector_of_vectors(triangle);
	// Call the static function
	triangle = static_triangle(n);
	cout<<endl<<"Calculated using static vectors:"<<endl<<endl;
	print_vector_of_vectors(triangle);
	return 0;
}
