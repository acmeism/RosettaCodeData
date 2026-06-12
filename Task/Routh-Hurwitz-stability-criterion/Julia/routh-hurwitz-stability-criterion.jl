using Polynomials

# Global epsilon for numerical stability checks (not the replacement epsilon)
const DEFAULT_TOLERANCE = 1e-9
# Epsilon value for replacing a zero in the first column, as per MATLAB code
const EPSILON_REPLACEMENT = 0.01

"""
Calculates the Routh-Hurwitz stability table and determines system stability.

Args:
    coeff_vector_in (list or np.array): Input vector of system coefficients
                                        (e.g., [an, an-1, ..., a0]).
    epss_replacement (float): Small value to replace zeros in the first column.
    tolerance (float): Tolerance for checking if a number is zero.

Returns:
    tuple: (rh_table, unstable_poles, is_stable, message)
            rh_table (np.array): The Routh-Hurwitz table.
            unstable_poles (int): Number of right-hand side poles.
            is_stable (bool): True if the system is stable, False otherwise.
            message (str): A message describing stability.
"""
function routh_hurwitz(coeff_vector_in::Vector, epss_replacement = EPSILON_REPLACEMENT, tolerance = DEFAULT_TOLERANCE)
    coeff_vector = Float64.(coeff_vector_in)
    coeff_length = length(coeff_vector)

    # Handle all-zero coefficient vector
    if all(abs.(coeff_vector) .< tolerance)
        num_coeffs_for_table = max(1, coeff_length)
        rh_cols_trivial = max((num_coeffs_for_table + 1) ÷ 2, 1)
        return zeros(num_coeffs_for_table, rh_cols_trivial), 0, false,
        "System has all zero coefficients, stability is ill-defined (considered unstable)."
    end
    # Trim leading zeros
    first_non_zero_idx = 0
    for (i, c) in enumerate(coeff_vector)
        if abs(c) > tolerance
            first_non_zero_idx = i - 1
            break
        end
        if i == coeff_length  # All were zero, caught by above check but as safeguard
            rh_cols_trivial = max(1, (coeff_length + 1) ÷ 2)
            return zeros(coeff_length, rh_cols_trivial), 0, false,
            "System has all zero coefficients after attempting to trim, stability is ill-defined (considered unstable)."
        end
    end
    coeff_vector = coeff_vector[begin+first_non_zero_idx:end]
    coeff_length = length(coeff_vector)

    if coeff_length == 0  # Should be caught by all-zero check if trimming led to empty
        return zeros(1, 1), 0, false, "Coefficient vector is empty after trimming."
    end
    if coeff_length == 1  # Zeroth order system: P(s) = a0
        rh_table_single = [[coeff_vector[begin]]]
        # A non-zero constant is stable (no roots, or root at infinity if viewed as 1/P(s))
        # A zero constant P(s)=0 has infinite roots, unstable.
        if abs(coeff_vector[begin]) < tolerance
            return rh_table_single, 0, false, "System is P(s)=0, unstable."  # Or 1 unstable pole at origin
        end
        return rh_table_single, 0, true, "System is stable (0th order, non-zero constant)."
    end

    # Ensure rh_table_column length is at least 1
    rh_table_column = max(1, (coeff_length + 1) ÷ 2)
    rh_table = zeros(coeff_length, rh_table_column)

    # Row 1 (Python index 0)
    row1_elements = coeff_vector[begin:2:end]
    rh_table[begin, begin:length(row1_elements)] .= row1_elements
    # Row 2 (Python index 1)
    if coeff_length > 1
        row2_elements = coeff_vector[begin+1:2:end]
        if length(row2_elements) > 0  # Check if there are any elements for the second row
            rh_table[begin+1, begin:length(row2_elements)] .= row2_elements
            # If coeff_length is odd, len(row2_elements) might be less than rh_table_column.
            # If coeff_length is 1 (e.g. P(s)=s), row2_elements will be empty.
            #   coeff_vector = [1,0]. len=2. rh_col=1. R1=[1]. R2=[0]. Correct.
        end
    end
    # Calculate other elements of the table
    # Python loop for i from 2 up to coeff_length-1 (for rh_table rows)
    # Corresponds to MATLAB loop for i_matlab from 3 up to coeff_length
    for i_py_row in 2:coeff_length-1
        prev_row_py = i_py_row - 1  # Python index of the row s^(n-(i_py_row-1))
        prev_prev_row_py = i_py_row - 2  # Python index of the row s^(n-(i_py_row-2))

        # Special case: row of all zeros (check rh_table[prev_row_py])
        # Effective number of columns to check for all-zero condition.
        # For row k (0-indexed), it's roughly rh_table_column - k//2.
        # For simplicity and to match MATLAB's apparent behavior of checking fixed width:
        if all(abs.(rh_table[begin+prev_row_py, :]) .< tolerance)
            # Auxiliary polynomial is formed from rh_table[prev_prev_row_py]
            # Its derivative's coefficients are placed into rh_table[prev_row_py]

            # Highest power of original polynomial: s^(coeff_length - 1)
            # Row prev_prev_row_py (0-indexed) corresponds to s^( (coeff_length-1) - prev_prev_row_py )
            # Highest power in aux poly: P_aux = (coeff_length - 1) - prev_prev_row_py
            highest_power_aux_poly = (coeff_length - 1) - prev_prev_row_py

            # If highest_power_aux_poly is 0 (constant term), derivative is 0.
            # This means rh_table[prev_row_py] will remain all zeros.
            # This could indicate multiple roots at origin or more complex jw-axis roots.
            if highest_power_aux_poly < 1  # Aux poly is constant or invalid
                # This implies rh_table[prev_prev_row_py] was effectively zero or just a0.
                # If rh_table[prev_row_py] remains all zero, this is a problem.
                # The Routh test might break down or indicate severe instability.
                # For now, let computation proceed; if first element is zero, epss will apply.
                # But if the whole row is zero again, the next iteration might also hit this.
                # To prevent issues or signal this degenerate case:
                if all(abs.(rh_table[begin+prev_prev_row_py, :]) < tolerance)  # Two consecutive all-zero rows
                    return rh_table, coeff_length, false, "System unstable: Two consecutive all-zero rows encountered."
                end
                # If aux poly source is non-zero but leads to zero derivative (e.g. it was a constant)
                # then the row prev_row_py remains zero. This is problematic.
                # The code below will attempt to fill it. If it stays zero, the next loop iter
                # will find prev_row_py (which becomes current_row_py-1) as all zero again.
                # This recursive all-zero needs a limit or specific handling.
                # For now, if derivative is zero, the row rh_table[prev_row_py] is not changed from zeros.
                # Let it be, next calculations will use zeros or epss
            end
            all_zeros_generated_for_aux_row = true
            for j_col in 0:rh_table_column-2  # Iterate to fill derivative coeffs
                # Power for term rh_table[prev_prev_row_py, j_col] in aux_poly is highest_power_aux_poly - 2*j_col
                power_of_s_term = highest_power_aux_poly - 2 * j_col
                if power_of_s_term >= 0  # Differentiate valid term
                    coeff_val = rh_table[begin+prev_prev_row_py, begin+j_col]
                    rh_table[begin+prev_row_py, begin+j_col] = power_of_s_term * coeff_val
                    if abs(rh_table[begin+prev_row_py, begin+j_col]) > tolerance
                        all_zeros_generated_for_aux_row = false
                    end
                else  # No more terms in aux polynomial
                    rh_table[begin+prev_row_py, begin+j_col] = 0.0
                end
            end
            if all_zeros_generated_for_aux_row && highest_power_aux_poly >= 1
                # This means aux poly was non-trivial (e.g. s^2) but all its coeffs in table were zero.
                # Or, derivative itself is identically zero (e.g. from P(s)=constant).
                # This is a critical failure point for Routh array construction.
                # The MATLAB code implies this derived row would then be used.
                # If it's still all zeros, the process might repeat or fail.
                # A truly robust handler might stop here or flag.
                # For strict MATLAB translation, we assume the derived row is used.
                # If rh_table[prev_row_py,0] is zero, the epss replacement will occur later for that element.
                #
            end
        end
            # Denominator for the current row's calculation
        denominator = rh_table[begin+prev_row_py, begin]

        if abs(denominator) < tolerance
            # This means the first element of the previous row was zero.
            # It should have been replaced by epss_replacement in its own calculation step.
            # If it's still zero, it means epss_replacement itself might be zero,
            # or it was part of an all-zero row whose derivative was also zero at that point.
            if abs(epss_replacement) < tolerance  # Epsilon itself is zero, cannot recover
                return rh_table, coeff_length, false,
                "System unstable or ill-defined: Division by zero, and epsilon ($epss_replacement) is zero."
            end
            denominator = epss_replacement  # Use epsilon as denominator robustly
        end
        for j_col in 0:rh_table_column-2
            # rh_table[i_py_row, j_col] = ( (rh_table[prev_row_py, 0] * rh_table[prev_prev_row_py, j_col+1]) -
            #                               (rh_table[prev_prev_row_py, 0] * rh_table[prev_row_py, j_col+1]) ) / denominator

            # Ensure indices are within bounds for safety, NumPy slicing with padding handles this mostly.
            val_prev_prev_j_plus_1 = j_col + 1 < rh_table_column ? rh_table[begin+prev_prev_row_py, begin+j_col+1] : 0.0
            val_prev_j_plus_1 = j_col + 1 < rh_table_column ? rh_table[begin+prev_row_py, begin+j_col+1] : 0.0

            numerator = (rh_table[begin+prev_row_py, begin] * val_prev_prev_j_plus_1) -
                        (rh_table[begin+prev_prev_row_py, begin] * val_prev_j_plus_1)

            if abs(denominator) < tolerance  # Should have been caught and set to epss_replacement
                rh_table[begin+i_py_row, begin+j_col] = Inf  # Should not happen if epss_replacement is non-zero
            else
                rh_table[begin+i_py_row, begin+j_col] = numerator / denominator
            end
        end
        # Special case: zero in the first column of the *newly computed* row (i_py_row)
        # This is the direct translation of the MATLAB `if rhTable(i,1) == 0; rhTable(i,1) = epss; end`
        if abs(rh_table[begin+i_py_row, begin]) < tolerance
            # Check if this row is entirely zeros. If so, it will be handled by aux poly in next iteration.
            # Applying epss here would prevent that.
            # However, strict MATLAB code does not make this distinction here. It just applies epss.
            rh_table[begin+i_py_row, begin] = epss_replacement
        end
    end
    # Compute number of right hand side poles
    unstable_poles = 0
    first_column_values = rh_table[:, begin]

    for k in 0:coeff_length-2
        sign_curr = sign(first_column_values[begin+k])
        sign_next = sign(first_column_values[begin+k+1])

        # If epss_replacement is used, it's positive, so sign is 1.
        # np.sign(0) is 0. product sign_curr * sign_next will be 0, not -1.
        if sign_curr * sign_next == -1
            unstable_poles += 1
        end
    end
    is_stable_system = (unstable_poles == 0)

    # Refine stability message (MATLAB script is basic here)
    # A row of zeros during computation (even if replaced by aux poly) indicates roots on jw-axis
    # or symmetrically located roots. If unstable_poles is 0 in such a case, it's marginally stable.
    # The original MATLAB code doesn't distinguish "stable" vs "marginally stable".
    # We will follow that: 0 RHP poles = stable.
    stability_message = is_stable_system ? "System is STABLE." :
        "System is UNSTABLE with $unstable_poles pole(s) in the RHP."
    return rh_table, unstable_poles, is_stable_system, stability_message
end

function print_routh_details(coeff_vector_str_in, rh_table, unstable_poles, is_stable, message;
    show_roots_opt = false, original_coeffs_in = Float64[], tolerance = DEFAULT_TOLERANCE)
    println("\nFor coefficient vector: $coeff_vector_str_in")
    println("Routh-Hurwitz Table:")
    if !isempty(rh_table)
        rh_table_print = deepcopy(rh_table)
        # Replace very small numbers with 0 for cleaner printing
        rh_table_print[abs.(rh_table_print) .< tolerance * 10] .= 0.0

        str_table_rows = Vector{Float64}[]
        max_char_len = 0
        for row_idx in 0:size(rh_table_print, 1)-1
            str_row_elems = Float64[]
            # Determine effective columns for this row to avoid printing excessive trailing zeros
            # This is an enhancement over simple MATLAB display. For strictness, print all.
            # Let's print up to the last non-zero element per row for clarity, or at least first element.
            effective_cols_this_row = size(rh_table_print, 2)
            # Heuristic: find last significant element in this row
            last_sig_idx = 0
            for col_idx in 0:size(rh_table_print, 2)-1
                if abs(rh_table_print[begin+row_idx, begin+col_idx]) > tolerance
                    last_sig_idx = col_idx
                end
            end
            effective_cols_this_row = max(1, last_sig_idx + 1)

            for col_idx in 0:effective_cols_this_row-1  # Iterate only over effective columns
                x = rh_table_print[begin+row_idx, begin+col_idx]
                rounded = round(x, digits = 4)  # General format, up to 4 digits
                max_char_len = max(max_char_len, length(string(rounded)))
                push!(str_row_elems, rounded)
            end
            push!(str_table_rows, str_row_elems)
        end

        for str_row_elems in str_table_rows
            formatted_row_elems = [lpad(s, max_char_len) for s in str_row_elems]
            println(join(formatted_row_elems, " | "))
        end
    else
        println("(Table generation failed or system trivial/empty)")
    end
    println("\n$message")
    # print(f"Number of right-hand side poles = {unstable_poles}") # Included in message

    if show_roots_opt && !isempty(original_coeffs_in)
        coeffs_for_roots_finding = Float64.(original_coeffs_in)
        # Trim leading zeros for np.roots
        first_nz_idx = 0
        for (i_nz, c_nz) in enumerate(coeffs_for_roots_finding)
            if abs(c_nz) > tolerance
                first_nz_idx = i_nz - 1
                break
            end
            if i_nz == length(coeffs_for_roots_finding)  # all zeros
                first_nz_idx = length(coeffs_for_roots_finding)  # make it empty
            end
        end
        coeffs_for_roots_finding = coeffs_for_roots_finding[begin+first_nz_idx:end]

        if length(coeffs_for_roots_finding) > 1  # Need at least s^1 + a0 = 0
            try
                sys_roots_val = roots(Polynomial(reverse(coeffs_for_roots_finding)))
                println("\nRoots of the polynomial:")
                for r_val in sys_roots_val
                    println("  ", round(abs(imag(r_val)) > tolerance ? r_val : real(r_val), digits = 4))
                end
            catch e
                println("\nCould not compute roots (possibly due to polynomial structure).")
            end
        elseif length(coeffs_for_roots_finding) == 1 && abs(coeffs_for_roots_finding[begin]) > tolerance  # P(s) = K !=0
            println("\nPolynomial is a non-zero constant (0th order), no roots in finite plane.")
        else  # P(s) = 0 or empty
            println("\nPolynomial is trivial (e.g., 0 or empty), roots are undefined or infinite.")
        end
    end
end

test_cases = [
    ("Stable: s^3 + 6s^2 + 11s + 6", [1, 6, 11, 6]),
    ("Unstable: s^3 - 6s^2 + 11s - 6", [1, -6, 11, -6]),
     ("Marginally Stable (jw-axis, Row of Zeros): s^3 + s^2 + s + 1", [1, 1, 1, 1]),
     ("Marginally Stable (jw-axis, Row of Zeros): s^2 + 1", [1, 0, 1]),
     ("Marginally Stable (epsilon case): s^3 + 2s^2 + s + 2", [1, 2, 1, 2]),
     ("Unstable (row of zeros & RHP): s^5 + 2s^4 + 3s^3 + 6s^2 + 5s + 10", [1, 2, 3, 6, 5, 10]),
]

function test_routh_hurwitz(show_all_roots_main = true)
    for (desc, coeffs_main) in test_cases
        println("--- Testing Case: $desc ---")
        try
            rh_table_res, unstable_poles_res, is_stable_res, message_res = routh_hurwitz(coeffs_main)
            print_routh_details(string(coeffs_main), rh_table_res, unstable_poles_res, is_stable_res, message_res,
                show_roots_opt = show_all_roots_main, original_coeffs_in = coeffs_main)
        catch e
            println("Error during Routh-Hurwitz calculation for {coeffs_main}: $e")
            # Optionally, try to print roots even if Routh failed
            if show_all_roots_main
                print_routh_details(string(coeffs_main), Matrix{Float64}[], -1, false, "Routh calc failed.",
                    show_roots_opt = true, original_coeffs_in = coeffs_main)
            end
            rethrow()
        end
        println("-"^88, "\n")
    end
end

test_routh_hurwitz()
