// Ported from https://codereview.stackexchange.com/questions/187588

// Make the BLOSUM matrix into a class for easier retrieval
class BLOSUM62 {
  constructor() {
    this.scoring_matrix = {};
    const fs = require('fs');
    const entries = fs.readFileSync('BLOSUM62.txt', 'utf8')
      .split('\n')
      .map(line => line.trim().split(/\s+/));

    for (const entry of entries) {
      if (entry.length >= 3) {
        this.scoring_matrix[[entry[0], entry[1]]] = parseInt(entry[2]);
      }
    }
  }

  getItem(pair) {
    return this.scoring_matrix[[pair[0], pair[1]]];
  }
}

function local_alignment(v, w, scoring_matrix, gap_start, gap_extend) {
  // Initialize the 3 matrices
  const M = Array(v.length + 1).fill().map(() => Array(w.length + 1).fill(0));
  const X = Array(v.length + 1).fill().map(() => Array(w.length + 1).fill(0));
  const Y = Array(v.length + 1).fill().map(() => Array(w.length + 1).fill(0));
  const back_track = Array(v.length + 1).fill().map(() => Array(w.length + 1).fill(0));

  // Initialize the maximum scores
  let max_score = -1;
  let max_i = 0, max_j = 0;

  // Populate all three matrices
  for (let i = 1; i <= v.length; i++) {
    for (let j = 1; j <= w.length; j++) {
      Y[i][j] = Math.max(Y[i-1][j] - gap_extend, M[i-1][j] - gap_start);
      X[i][j] = Math.max(X[i][j-1] - gap_extend, M[i][j-1] - gap_start);

      const cur_scores = [
        Y[i][j],
        M[i-1][j-1] + scoring_matrix.getItem([v[i-1], w[j-1]]),
        X[i][j],
        0
      ];

      M[i][j] = Math.max(...cur_scores);
      back_track[i][j] = cur_scores.indexOf(M[i][j]);

      if (M[i][j] > max_score) {
        max_score = M[i][j];
        max_i = i;
        max_j = j;
      }
    }
  }

  console.log('Finished making the matrix');

  // Initialize the indices to start at the position of the high score
  let i = max_i, j = max_j;

  // Initialize the aligned strings as the input strings up to the position of the high score
  let v_aligned = v.substring(0, i);
  let w_aligned = w.substring(0, j);

  // Backtrack to start of the local alignment starting at the highest scoring cell
  while (back_track[i][j] !== 3 && i * j !== 0 && i >= j) {
    if (back_track[i][j] === 0) {
      i -= 1;
    } else if (back_track[i][j] === 1) {
      i -= 1;
      j -= 1;
    } else if (back_track[i][j] === 2) {
      j -= 1;
    }
  }

  console.log('finished backtracking');

  // Cut the strings at the ending point of the backtrack
  v_aligned = v_aligned.substring(i);
  w_aligned = w_aligned.substring(j);

  return [max_score.toString(), v_aligned, w_aligned];
}

// Read the input file
const fs = require('fs');
let indata = fs.readFileSync('rosalind_laff.txt', 'utf8').split('\n');
indata.push('>');

let word1 = '';
let word2 = '';
let linenum = 0;
let chunk = [];

for (const line of indata) {
  const trimmedLine = line.trim();
  linenum = linenum + 1;

  if (trimmedLine === '') {
    continue;
  } else {
    if (trimmedLine[0] === '>') {
      if (linenum === 1) {
        chunk = [];
      } else if (linenum > 1 && linenum !== indata.length) {
        word1 = chunk.join('');
        chunk = [];
      } else {
        word2 = chunk.join('');
      }
    } else {
      chunk.push(trimmedLine);
    }
  }
}

// Get the local alignment (given sigma = 11, epsilon = 1 in problem statement)
const blosum = new BLOSUM62();
const alignment = local_alignment(word1, word2, blosum, 11, 1);

// Print and save the answer
console.log(alignment.join('\n'));

fs.writeFileSync('out_localali_test.txt', alignment.toString());
