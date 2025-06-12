/**
 * Helper function to print a 2D array (matrix) nicely.
 * @param {Array<Array<any>>} matrix The matrix to print.
 * @param {string} title Optional title to print before the matrix.
 */
function printMatrix(matrix, title = "") {
    if (title) {
        console.log(title);
    }
    // console.table is often available and provides good formatting
    if (typeof console.table === 'function') {
        console.table(matrix);
    } else {
        // Fallback basic printing
        matrix.forEach(row => {
            // JSON.stringify formats arrays with commas and brackets
            console.log(JSON.stringify(row));
        });
    }
}

// --- Input Data ---
// Using let for demand and supply as they will be modified during the algorithm
// Make copies if you want to preserve the original arrays elsewhere
let demand = [30, 20, 70, 30, 60];
let supply = [50, 60, 50, 50];
const costs = [
    [16, 16, 13, 22, 17],
    [14, 14, 13, 19, 15],
    [19, 19, 20, 23, 50],
    [50, 12, 50, 15, 11]
];

// --- Dimensions and State Variables ---
const nRows = supply.length;
const nCols = demand.length;

// Track which rows/columns are fully satisfied
const rowDone = Array(nRows).fill(false);
const colDone = Array(nCols).fill(false);

// The resulting allocation matrix, initialized with zeros
const result = Array(nRows).fill(0).map(() => Array(nCols).fill(0));

/**
 * Calculates the difference between the two smallest costs in a given row or column,
 * considering only active (not done) cells.
 * @param {number} j The index of the row or column to analyze.
 * @param {number} len The length of the other dimension (nCols if analyzing a row, nRows if analyzing a column).
 * @param {boolean} isRow True if analyzing row j, false if analyzing column j.
 * @returns {Array<number>} An array: [penalty, minCost, minCostPosition]
 *                          penalty = min2 - min1 (Infinity if < 2 costs found)
 *                          minCost = the smallest cost found (Infinity if none found)
 *                          minCostPosition = index of the smallest cost (-1 if none found)
 */
function diff(j, len, isRow) {
    let min1 = Infinity;
    let min2 = Infinity;
    let minP = -1; // Position (index) of min1

    for (let i = 0; i < len; i++) {
        // Skip if the corresponding column (if analyzing row) or row (if analyzing column) is already done
        if (isRow ? colDone[i] : rowDone[i]) {
            continue;
        }

        // Get the cost from the correct cell
        const c = isRow ? costs[j][i] : costs[i][j];

        if (c < min1) {
            min2 = min1; // Old min1 becomes min2
            min1 = c;    // New cost is the new min1
            minP = i;    // Record position of new min1
        } else if (c < min2) {
            min2 = c; // Update min2
        }
    }

    // Calculate penalty: difference between second minimum and first minimum
    // If min2 is still Infinity, it means less than two costs were found. Penalty is Infinity.
    const penalty = (min2 === Infinity) ? Infinity : min2 - min1;

    return [penalty, min1, minP];
}

/**
 * Finds the row or column with the maximum penalty among active rows/columns.
 * @param {number} len1 Number of rows or columns to iterate through (nRows or nCols).
 * @param {number} len2 Length of the other dimension (nCols or nRows).
 * @param {boolean} isRow True if finding max penalty among rows, false for columns.
 * @returns {Array<number> | null} An array: [rowIndex, colIndex, minCostInSelected, maxPenaltyValue]
 *                                Returns null if no active rows/columns found.
 */
function maxPenalty(len1, len2, isRow) {
    let maxDiff = -Infinity; // Use -Infinity to ensure any real penalty is larger
    let posOfMaxDiff = -1;   // Index of row/column with max penalty
    let posOfMinCost = -1;   // Index of min cost within the selected row/column
    let minCostVal = -1;     // Value of min cost within the selected row/column
    let foundActive = false;

    for (let i = 0; i < len1; i++) {
        // Skip if this row (if isRow) or column (if !isRow) is already done
        if (isRow ? rowDone[i] : colDone[i]) {
            continue;
        }
        foundActive = true; // Found at least one active row/column to check

        const res = diff(i, len2, isRow); // [penalty, minCost, minPos]
        const currentPenalty = res[0];

        // Check if this penalty is the highest found so far
        if (currentPenalty > maxDiff) {
            maxDiff = currentPenalty;
            posOfMaxDiff = i;         // Record which row/column had this max penalty
            minCostVal = res[1];      // Record the min cost in this row/column
            posOfMinCost = res[2];    // Record the position of min cost
        }
    }
    if (!foundActive) {
        return null; // No active rows/columns left to calculate penalty for
    }

    // Return results ensuring format [rowIndex, colIndex, minCostVal, maxDiff]
    return isRow
        ? [posOfMaxDiff, posOfMinCost, minCostVal, maxDiff] // For row: [rowIdx, colIdxOfMin, minCost, penalty]
        : [posOfMinCost, posOfMaxDiff, minCostVal, maxDiff]; // For col: [rowIdxOfMin, colIdx, minCost, penalty]
}

/**
 * Determines the next cell to allocate to based on Vogel's Approximation Method (VAM).
 * It compares the highest row penalty and the highest column penalty.
 * @returns {Array<number> | null} An array: [rowIndex, colIndex, minCostInSelected, maxPenaltyValue]
 *                                 Returns null if no suitable cell can be found.
 */
function nextCell() {
    const resRow = maxPenalty(nRows, nCols, true);  // Max penalty among rows
    const resCol = maxPenalty(nCols, nRows, false); // Max penalty among columns

    // Handle cases where one or both couldn't find penalties (e.g., all done)
     if (!resRow && !resCol) return null; // No more valid moves
     if (!resRow) return resCol;          // Only column penalty found
     if (!resCol) return resRow;          // Only row penalty found

    const maxPenaltyRow = resRow[3];
    const maxPenaltyCol = resCol[3];
    const minCostInRow = resRow[2];
    const minCostInCol = resCol[2];

    // Decide based on highest penalty. Break ties by choosing the one with the lower minimum cost.
    if (maxPenaltyRow === maxPenaltyCol) {
        return minCostInRow <= minCostInCol ? resRow : resCol;
    } else {
        // In the C++ code: `res1[3] > res2[3] ? res2 : res1;`
        // This seems backward? Higher penalty should be chosen.
        // Let's assume higher penalty is better:
        // return maxPenaltyRow >= maxPenaltyCol ? resRow : resCol;
        // Let's stick to the C++ code's logic for direct translation:
         return maxPenaltyRow > maxPenaltyCol ? resCol : resRow;
         // Re-evaluating C++ code:
         // `auto res1 = maxPenalty(nRows, nCols, true);` -> `res1` = row result
         // `auto res2 = maxPenalty(nCols, nRows, false);` -> `res2` = col result
         // `return res1[3] > res2[3] ? res2 : res1;` -> If row penalty > col penalty, return col result. This is incorrect VAM.
         // VAM selects the *highest* penalty.
         // Let's correct the logic based on VAM principle: Choose highest penalty, break ties with lowest cost.
        //
        // if (maxPenaltyRow > maxPenaltyCol) {
        //     return resRow;
        // } else if (maxPenaltyCol > maxPenaltyRow) {
        //     return resCol;
        // } else {
        //     // Penalties are equal, break tie with minimum cost
        //     return minCostInRow <= minCostInCol ? resRow : resCol;
        // }
        //
        // The logic `maxPenaltyRow > maxPenaltyCol ? resCol : resRow` actually means:
        // If RowPenalty is bigger, return ColumnResult. If ColPenalty is bigger or equal, return RowResult.
        // This seems highly suspect and likely a bug in the original C++ or a misunderstanding of its output.
        // Let's implement the standard VAM logic (highest penalty wins, tiebreak with cost):
        if (maxPenaltyRow > maxPenaltyCol) {
            return resRow;
        } else if (maxPenaltyCol > maxPenaltyRow) {
            return resCol;
        } else {
            // Penalties are equal, break tie with minimum cost cell within the tied lines
            return minCostInRow <= minCostInCol ? resRow : resCol;
        }
    }
}


// --- Main VAM Algorithm Execution ---

// Calculate total initial supply
let supplyLeft = supply.reduce((sum, current) => sum + current, 0);
let totalCost = 0;
let iterations = 0; // Safety counter
const maxIterations = nRows * nCols * 2; // A reasonable upper bound

console.log("Starting Vogel's Approximation Method...");
console.log("Initial Supply:", supply);
console.log("Initial Demand:", demand);
console.log("Costs:");
printMatrix(costs);
console.log("---");


while (supplyLeft > 0 && iterations < maxIterations) {
    iterations++;
    const cell = nextCell(); // Get [r, c, minCost, penalty] for the next allocation

    if (!cell) {
        console.log("No suitable cell found by nextCell(). Stopping.");
        break; // No more valid moves can be determined
    }

    const r = cell[0]; // Row index to allocate to
    const c = cell[1]; // Column index to allocate to

    // Safety check for valid indices and if the cell's row/col are already done
    // This shouldn't happen if maxPenalty correctly skips done rows/cols, but good for robustness.
    if (r < 0 || r >= nRows || c < 0 || c >= nCols || rowDone[r] || colDone[c]) {
        console.warn(`Iteration ${iterations}: nextCell returned invalid/done cell [${r}, ${c}]. Attempting to recover or break.`);
        // Attempt recovery: mark potentially problematic row/col as done if indices are valid
        if (r >= 0 && r < nRows) rowDone[r] = true;
        if (c >= 0 && c < nCols) colDone[c] = true;
        // Or simply break:
        // break;
        continue; // Try finding another cell in the next iteration
    }


    // Determine the quantity to allocate: minimum of remaining supply in row r and demand in col c
    const quantity = Math.min(demand[c], supply[r]);

    if (quantity <= 0) {
         // This might happen if a row/col is selected but has 0 supply/demand left.
         // Mark them as done and continue.
         console.warn(`Iteration ${iterations}: Zero quantity allocation attempted for cell [${r}, ${c}]. Marking row/col as done.`);
         if (demand[c] <= 0 && !colDone[c]) colDone[c] = true;
         if (supply[r] <= 0 && !rowDone[r]) rowDone[r] = true;
         continue;
    }


    // Update demand, supply, and mark as done if depleted
    demand[c] -= quantity;
    if (demand[c] === 0) {
        colDone[c] = true;
    }

    supply[r] -= quantity;
    if (supply[r] === 0) {
        rowDone[r] = true;
    }

    // Record the allocation in the result matrix
    result[r][c] = quantity;

    // Update total supply left and total cost
    supplyLeft -= quantity;
    totalCost += quantity * costs[r][c];

    // console.log(`Iteration ${iterations}: Allocated ${quantity} to [${r}, ${c}]. Cost += ${quantity * costs[r][c]}. SupplyLeft: ${supplyLeft}`);
    // console.log(" Current Supply:", supply);
    // console.log(" Current Demand:", demand);
    // console.log(" rowDone:", rowDone);
    // console.log(" colDone:", colDone);
    // console.log("---");

}

if (iterations >= maxIterations) {
    console.warn("Warning: Maximum iterations reached. The algorithm might be stuck in a loop.");
}

// --- Output Results ---
console.log("\n--- VAM Finished ---");
printMatrix(result, "Allocation Matrix (Result):");
console.log(`\nTotal Cost: ${totalCost}`);

// Optional: Check final state
const remainingDemand = demand.reduce((s, d) => s + d, 0);
const remainingSupply = supply.reduce((s, sup) => s + sup, 0);
console.log(`Final Remaining Demand: ${remainingDemand}`);
console.log(`Final Remaining Supply: ${remainingSupply}`);
console.log(`Calculated Supply Left: ${supplyLeft}`);

// Verify if total allocated matches total demand/supply (assuming balanced problem)
const totalAllocated = result.flat().reduce((s, q) => s + q, 0);
console.log(`Total Quantity Allocated: ${totalAllocated}`);
