#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <ctime>

using namespace std;

string addSeconds(string timeStr, int secs) {
	int hours, minutes, seconds, milliseconds;
	sscanf(timeStr.c_str(), "%d:%d:%d,%d", &hours, &minutes, &seconds, &milliseconds);
	int total_seconds = hours * 3600 + minutes * 60 + seconds + secs;
	hours = total_seconds / 3600;
	total_seconds %= 3600;
	minutes = total_seconds / 60;
	seconds = total_seconds % 60;
	char buffer[13];
	sprintf(buffer, "%02d:%02d:%02d,%03d", hours, minutes, seconds, milliseconds);
	return string(buffer);
}

void syncSubtitles(string fileIn, string fileOut, int secs) {
	ifstream fin(fileIn);
	ofstream fout(fileOut);
	string line;
	while (getline(fin, line)) {
		if (line.find("-->") != string::npos) {
			string start = line.substr(0, 12);
			string end = line.substr(17, 12);
			start = addSeconds(start, secs);
			end = addSeconds(end, secs);
			fout << start << " --> " << end << "\n";
		} else {
			fout << line << "\n";
		}
	}
	fin.close();
	fout.close();
}

int main() {
	cout << "After fast-forwarding 9 seconds:\n\n";
	syncSubtitles("movie.srt", "movie_corrected.srt", 9);
	ifstream f("movie_corrected.srt");
	string line;
	while (getline(f, line)) {
		cout << line << "\n";
	}
	f.close();
	
	cout << "\n\nAfter rolling-back 9 seconds:\n\n";
	syncSubtitles("movie.srt", "movie_corrected2.srt", -9);
	ifstream f2("movie_corrected2.srt");
	while (getline(f2, line)) {
		cout << line << "\n";
	}
	f2.close();
	
	return 0;
}
