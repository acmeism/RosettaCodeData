/* ExternalSort.cpp */


#include <iostream>
#include <fstream>
#include <queue>
#include <string>
#include <algorithm>
#include <cstdio>


/* function signatures */

int main(int argc, char* argv[]);
void write_vals(int* const, const size_t, const size_t);
std::string mergeFiles(size_t);


/* Comparison object

   compares first item of 2 std::pairs of ints
   true if first item is larger or the same.

   MinHeap sorts with this.
   It gets called a lot, so the simpler the better.

   STL api stipulates boolean predicate

   A "functor" object defines a function call operator () that returns a value.

*/

struct Compare
{
  // compare 2 pairs by first element
  bool operator() ( std::pair<int, int>& p1,  std::pair<int, int>& p2 )
  {
    return p1.first >= p2.first; // Ascending order
  }
};




/* aliases */

using ipair = std::pair<int,int>;

using pairvector = std::vector<ipair>;

using MinHeap = std::priority_queue< ipair, pairvector, Compare >;




/* constants */

const size_t memsize = 32;                        // 32 bytes

const size_t chunksize = memsize / sizeof(int);   // 8 int

const std::string tmp_prefix{"tmp_out_"};  // tmpfile prefix

const std::string tmp_suffix{".txt"};      // tmpfile suffix

const std::string merged_file{"merged.txt"}; // output file



/* functions  */

// write  int array to file
void write_vals( int* const values, const size_t size, const size_t chunk )
{

  // tmp_out_1.txt,  tmp_out_2.txt ...
  std::string output_file = (tmp_prefix + std::to_string(chunk) + tmp_suffix);

  std::ofstream ofs(output_file.c_str()); //output file

  for (int i=0; i<size; i++)
    ofs << values[i] << '\t';

    ofs << '\n';

  ofs.close();
}



/* merge all external sorted files into one
   output file (same size as original input file) */

std::string mergeFiles(size_t chunks, const std::string& merge_file )
{

  std::ofstream ofs( merge_file.c_str() );

  MinHeap  minHeap;

  // array of ifstreams
  std::ifstream* ifs_tempfiles = new std::ifstream[chunks];

  for (size_t i = 1; i<=chunks; i++)
    {
      int topval = 0;	

      // generate a unique name for temp file (temp_out_1.txt , temp_out_2.txt ..)
      std::string sorted_file = (tmp_prefix + std::to_string(i) + tmp_suffix);

      // open an input file stream object for each name
      ifs_tempfiles[i-1].open( sorted_file.c_str() ); // bind to tmp_out_{i}.txt

      // get val from temp file
      if (ifs_tempfiles[i-1].is_open())
	{
	  ifs_tempfiles[i-1] >> topval; // first value in the file (min)

	  ipair top(topval, (i-1)); // 2nd value is tempfile number
			
	  minHeap.push( top );   //  minHeap autosorts
	}
    }


  while (minHeap.size() > 0)
    {
      int next_val = 0;

      ipair min_pair = minHeap.top(); // get min

      minHeap.pop();

      ofs << min_pair.first << ' ';  // write value to file

      std::flush(ofs);

      if ( ifs_tempfiles[min_pair.second] >> next_val)
	{

	  ipair np( next_val, min_pair.second );

	  minHeap.push( np );
	}

    }


  // close open files
  for (int i = 1; i <= chunks; i++)
    {
      ifs_tempfiles[i-1].close();
    }

  ofs << '\n';
  ofs.close();

  delete[] ifs_tempfiles; // free memory

  return merged_file;  // string
}




int main(int argc, char* argv[] )
{

  if (argc < 2)
    {
      std::cerr << "usage:  ExternalSort <filename> \n";
      return 1;
    }

  // open input file for reading

  std::ifstream ifs( argv[1] );

  if ( ifs.fail() )
    {
      std::cerr << "error opening " << argv[1] << "\n";
      return 2;
    }


  // temp array for input (small)  (32 bytes -- 8 ints)
  int* inputValues = new int[chunksize];

  int chunk = 1;    // counter (which chunk)

  int val = 0;      // int  for reading

  int count = 0;    // count reads

  bool done = false;

  std::cout << "internal buffer is " << memsize << " bytes" << "\n";

  // read chunksize values from input file
  while (ifs >> val)
    {
      done = false;

      inputValues[count] = val;
	
      count++;

      if (count == chunksize)
	{

	  std::sort(inputValues, inputValues + count);

	  write_vals(inputValues, count, chunk); // output vals to

	  chunk ++;

	  count = 0;

	  done = true;
	}

    } // while


  if (! done)  // one more file
    {
      std::sort(inputValues, inputValues + count);

      write_vals(inputValues, count, chunk); // output vals to
    }
  else
    {
      chunk --;  // fix overshoot
    }



  ifs.close();   // done with original input file


  delete[] inputValues; // free dynamically allocated memory


  // perform external mergesort on sorted temp files, if any.
  if ( chunk == 0 )
    std::cout << "no data found\n";
  else
    std::cout << "Sorted output is in file: " << mergeFiles(chunk, merged_file ) << "\n";


  return EXIT_SUCCESS;
}

/* compile:  clang++ -std=c++11 -Wall -pedantic -o ExternalSort ExternalSort.cpp */

/* inputfile  integers --  one per line for simplicity */
