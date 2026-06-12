import numpy as np
import math

# Global epsilon for numerical stability checks (not the replacement epsilon)
DEFAULT_TOLERANCE = 1e-9
# Epsilon value for replacing a zero in the first column, as per MATLAB code
EPSILON_REPLACEMENT = 0.01


def routh_hurwitz(coeff_vector_in, epss_replacement=EPSILON_REPLACEMENT, tolerance=DEFAULT_TOLERANCE):
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
    if not isinstance(coeff_vector_in, (list, np.ndarray)):
        raise TypeError("coeff_vector must be a list or numpy array.")

    coeff_vector = np.array(coeff_vector_in, dtype=float)

    if coeff_vector.ndim != 1:
        raise ValueError("coeff_vector must be a 1D array.")

    # Handle all-zero coefficient vector
    if np.all(np.abs(coeff_vector) < tolerance):
        num_coeffs_for_table = len(coeff_vector) if len(coeff_vector) > 0 else 1
        rh_cols_trivial = math.ceil(num_coeffs_for_table / 2.0) if num_coeffs_for_table > 0 else 1
        return np.zeros((num_coeffs_for_table, rh_cols_trivial)), 0, False, \
            "System has all zero coefficients, stability is ill-defined (considered unstable)."

    # Trim leading zeros
    first_non_zero_idx = 0
    for i, c in enumerate(coeff_vector):
        if abs(c) > tolerance:
            first_non_zero_idx = i
            break
        if i == len(coeff_vector) - 1:  # All were zero, caught by above check but as safeguard
            rh_cols_trivial = math.ceil(len(coeff_vector) / 2.0) if len(coeff_vector) > 0 else 1
            return np.zeros((len(coeff_vector), rh_cols_trivial)), 0, False, \
                "System has all zero coefficients after attempting to trim, stability is ill-defined (considered unstable)."

    coeff_vector = coeff_vector[first_non_zero_idx:]
    coeff_length = len(coeff_vector)

    if coeff_length == 0:  # Should be caught by all-zero check if trimming led to empty
        return np.zeros((1, 1)), 0, False, "Coefficient vector is empty after trimming."

    if coeff_length == 1:  # Zeroth order system: P(s) = a0
        rh_table_single = np.array([[coeff_vector[0]]])
        # A non-zero constant is stable (no roots, or root at infinity if viewed as 1/P(s))
        # A zero constant P(s)=0 has infinite roots, unstable.
        if abs(coeff_vector[0]) < tolerance:
            return rh_table_single, 0, False, "System is P(s)=0, unstable."  # Or 1 unstable pole at origin
        return rh_table_single, 0, True, "System is stable (0th order, non-zero constant)."

    rh_table_column = math.ceil(coeff_length / 2.0)
    # Ensure rh_table_column is at least 1
    rh_table_column = max(1, int(rh_table_column))

    rh_table = np.zeros((coeff_length, rh_table_column), dtype=float)

    # Row 1 (Python index 0)
    row1_elements = coeff_vector[0::2]
    rh_table[0, :len(row1_elements)] = row1_elements

    # Row 2 (Python index 1)
    if coeff_length > 1:
        row2_elements = coeff_vector[1::2]
        if len(row2_elements) > 0:  # Check if there are any elements for the second row
            rh_table[1, :len(row2_elements)] = row2_elements
        # If coeff_length is odd, len(row2_elements) might be less than rh_table_column.
        # If coeff_length is 1 (e.g. P(s)=s), row2_elements will be empty.
        #   coeff_vector = [1,0]. len=2. rh_col=1. R1=[1]. R2=[0]. Correct.

    # Calculate other elements of the table
    # Python loop for i from 2 up to coeff_length-1 (for rh_table rows)
    # Corresponds to MATLAB loop for i_matlab from 3 up to coeff_length
    for i_py_row in range(2, coeff_length):
        prev_row_py = i_py_row - 1  # Python index of the row s^(n-(i_py_row-1))
        prev_prev_row_py = i_py_row - 2  # Python index of the row s^(n-(i_py_row-2))

        # Special case: row of all zeros (check rh_table[prev_row_py])
        # Effective number of columns to check for all-zero condition.
        # For row k (0-indexed), it's roughly rh_table_column - k//2.
        # For simplicity and to match MATLAB's apparent behavior of checking fixed width:
        if np.all(np.abs(rh_table[prev_row_py, :]) < tolerance):
            # Auxiliary polynomial is formed from rh_table[prev_prev_row_py]
            # Its derivative's coefficients are placed into rh_table[prev_row_py]

            # Highest power of original polynomial: s^(coeff_length - 1)
            # Row prev_prev_row_py (0-indexed) corresponds to s^( (coeff_length-1) - prev_prev_row_py )
            # Highest power in aux poly: P_aux = (coeff_length - 1) - prev_prev_row_py
            highest_power_aux_poly = (coeff_length - 1) - prev_prev_row_py

            # If highest_power_aux_poly is 0 (constant term), derivative is 0.
            # This means rh_table[prev_row_py] will remain all zeros.
            # This could indicate multiple roots at origin or more complex jw-axis roots.
            if highest_power_aux_poly < 1:  # Aux poly is constant or invalid
                # This implies rh_table[prev_prev_row_py] was effectively zero or just a0.
                # If rh_table[prev_row_py] remains all zero, this is a problem.
                # The Routh test might break down or indicate severe instability.
                # For now, let computation proceed; if first element is zero, epss will apply.
                # But if the whole row is zero again, the next iteration might also hit this.
                # To prevent issues or signal this degenerate case:
                if np.all(np.abs(rh_table[prev_prev_row_py, :]) < tolerance):  # Two consecutive all-zero rows
                    return rh_table, coeff_length, False, "System unstable: Two consecutive all-zero rows encountered."
                # If aux poly source is non-zero but leads to zero derivative (e.g. it was a constant)
                # then the row prev_row_py remains zero. This is problematic.
                # The code below will attempt to fill it. If it stays zero, the next loop iter
                # will find prev_row_py (which becomes current_row_py-1) as all zero again.
                # This recursive all-zero needs a limit or specific handling.
                # For now, if derivative is zero, the row rh_table[prev_row_py] is not changed from zeros.
                pass  # Let it be, next calculations will use zeros or epss

            all_zeros_generated_for_aux_row = True
            for j_col in range(rh_table_column - 1):  # Iterate to fill derivative coeffs
                # Power for term rh_table[prev_prev_row_py, j_col] in aux_poly is highest_power_aux_poly - 2*j_col
                power_of_s_term = highest_power_aux_poly - 2 * j_col
                if power_of_s_term >= 0:  # Differentiate valid term
                    coeff_val = rh_table[prev_prev_row_py, j_col]
                    rh_table[prev_row_py, j_col] = power_of_s_term * coeff_val
                    if abs(rh_table[prev_row_py, j_col]) > tolerance:
                        all_zeros_generated_for_aux_row = False
                else:  # No more terms in aux polynomial
                    rh_table[prev_row_py, j_col] = 0.0

            if all_zeros_generated_for_aux_row and highest_power_aux_poly >= 1:
                # This means aux poly was non-trivial (e.g. s^2) but all its coeffs in table were zero.
                # Or, derivative itself is identically zero (e.g. from P(s)=constant).
                # This is a critical failure point for Routh array construction.
                # The MATLAB code implies this derived row would then be used.
                # If it's still all zeros, the process might repeat or fail.
                # A truly robust handler might stop here or flag.
                # For strict MATLAB translation, we assume the derived row is used.
                # If rh_table[prev_row_py,0] is zero, the epss replacement will occur later for that element.
                pass

        # Denominator for the current row's calculation
        denominator = rh_table[prev_row_py, 0]

        if abs(denominator) < tolerance:
            # This means the first element of the previous row was zero.
            # It should have been replaced by epss_replacement in its own calculation step.
            # If it's still zero, it means epss_replacement itself might be zero,
            # or it was part of an all-zero row whose derivative was also zero at that point.
            if abs(epss_replacement) < tolerance:  # Epsilon itself is zero, cannot recover
                return rh_table, coeff_length, False, \
                    f"System unstable or ill-defined: Division by zero, and epsilon ({epss_replacement}) is zero."
            denominator = epss_replacement  # Use epsilon as denominator robustly

        for j_col in range(rh_table_column - 1):
            # rh_table[i_py_row, j_col] = ( (rh_table[prev_row_py, 0] * rh_table[prev_prev_row_py, j_col+1]) -
            #                               (rh_table[prev_prev_row_py, 0] * rh_table[prev_row_py, j_col+1]) ) / denominator

            # Ensure indices are within bounds for safety, NumPy slicing with padding handles this mostly.
            val_prev_prev_j_plus_1 = rh_table[prev_prev_row_py, j_col + 1] if j_col + 1 < rh_table_column else 0.0
            val_prev_j_plus_1 = rh_table[prev_row_py, j_col + 1] if j_col + 1 < rh_table_column else 0.0

            numerator = (rh_table[prev_row_py, 0] * val_prev_prev_j_plus_1) - \
                        (rh_table[prev_prev_row_py, 0] * val_prev_j_plus_1)

            if abs(denominator) < tolerance:  # Should have been caught and set to epss_replacement
                rh_table[i_py_row, j_col] = np.inf  # Should not happen if epss_replacement is non-zero
            else:
                rh_table[i_py_row, j_col] = numerator / denominator

        # Special case: zero in the first column of the *newly computed* row (i_py_row)
        # This is the direct translation of the MATLAB `if rhTable(i,1) == 0; rhTable(i,1) = epss; end`
        if abs(rh_table[i_py_row, 0]) < tolerance:
            # Check if this row is entirely zeros. If so, it will be handled by aux poly in next iteration.
            # Applying epss here would prevent that.
            # However, strict MATLAB code does not make this distinction here. It just applies epss.
            rh_table[i_py_row, 0] = epss_replacement

    # Compute number of right hand side poles
    unstable_poles = 0
    first_column_values = rh_table[:, 0]

    for k in range(coeff_length - 1):
        sign_curr = np.sign(first_column_values[k])
        sign_next = np.sign(first_column_values[k + 1])

        # If epss_replacement is used, it's positive, so sign is 1.
        # np.sign(0) is 0. product sign_curr * sign_next will be 0, not -1.
        if sign_curr * sign_next == -1:
            unstable_poles += 1

    is_stable_system = (unstable_poles == 0)

    # Refine stability message (MATLAB script is basic here)
    # A row of zeros during computation (even if replaced by aux poly) indicates roots on jw-axis
    # or symmetrically located roots. If unstable_poles is 0 in such a case, it's marginally stable.
    # The original MATLAB code doesn't distinguish "stable" vs "marginally stable".
    # We will follow that: 0 RHP poles = stable.
    if is_stable_system:
        stability_message = "System is STABLE."
    else:
        stability_message = f"System is UNSTABLE with {unstable_poles} pole(s) in the RHP."

    return rh_table, unstable_poles, is_stable_system, stability_message


def print_routh_details(coeff_vector_str_in, rh_table, unstable_poles, is_stable, message,
                        show_roots_opt=False, original_coeffs_in=None, tolerance=DEFAULT_TOLERANCE):
    print(f"\nFor coefficient vector: {coeff_vector_str_in}")
    print("Routh-Hurwitz Table:")
    if rh_table is not None and rh_table.size > 0:
        rh_table_print = np.copy(rh_table)
        # Replace very small numbers with 0 for cleaner printing
        rh_table_print[np.abs(rh_table_print) < tolerance * 10] = 0.0

        str_table_rows = []
        max_char_len = 0
        for row_idx in range(rh_table_print.shape[0]):
            str_row_elems = []
            # Determine effective columns for this row to avoid printing excessive trailing zeros
            # This is an enhancement over simple MATLAB display. For strictness, print all.
            # Let's print up to the last non-zero element per row for clarity, or at least first element.
            effective_cols_this_row = rh_table_print.shape[1]
            # Heuristic: find last significant element in this row
            last_sig_idx = 0
            for col_idx in range(rh_table_print.shape[1]):
                if abs(rh_table_print[row_idx, col_idx]) > tolerance:
                    last_sig_idx = col_idx
            effective_cols_this_row = max(1, last_sig_idx + 1)

            for col_idx in range(effective_cols_this_row):  # Iterate only over effective columns
                x = rh_table_print[row_idx, col_idx]
                s = f"{x:.4g}"  # General format, up to 4 significant digits
                if len(s) > max_char_len:
                    max_char_len = len(s)
                str_row_elems.append(s)
            str_table_rows.append(str_row_elems)

        for str_row_elems in str_table_rows:
            formatted_row_elems = [s.rjust(max_char_len) for s in str_row_elems]
            print(" | ".join(formatted_row_elems))
    else:
        print("(Table generation failed or system trivial/empty)")

    print(f"\n{message}")
    # print(f"Number of right-hand side poles = {unstable_poles}") # Included in message

    if show_roots_opt and original_coeffs_in is not None:
        coeffs_for_roots_finding = np.array(original_coeffs_in, dtype=float)
        # Trim leading zeros for np.roots
        first_nz_idx = 0
        for i_nz, c_nz in enumerate(coeffs_for_roots_finding):
            if abs(c_nz) > tolerance:
                first_nz_idx = i_nz
                break
            if i_nz == len(coeffs_for_roots_finding) - 1:  # all zeros
                first_nz_idx = len(coeffs_for_roots_finding)  # make it empty

        coeffs_for_roots_finding = coeffs_for_roots_finding[first_nz_idx:]

        if len(coeffs_for_roots_finding) > 1:  # Need at least s^1 + a0 = 0
            try:
                sys_roots_val = np.roots(coeffs_for_roots_finding)
                print("\nRoots of the polynomial:")
                for r_val in sys_roots_val:
                    print(f"  {r_val.real:.4f} + {r_val.imag:.4f}j" if abs(
                        r_val.imag) > tolerance else f"  {r_val.real:.4f}")
            except np.linalg.LinAlgError:
                print("\nCould not compute roots (possibly due to polynomial structure).")
        elif len(coeffs_for_roots_finding) == 1 and abs(coeffs_for_roots_finding[0]) > tolerance:  # P(s) = K !=0
            print("\nPolynomial is a non-zero constant (0th order), no roots in finite plane.")
        else:  # P(s) = 0 or empty
            print("\nPolynomial is trivial (e.g., 0 or empty), roots are undefined or infinite.")


if __name__ == '__main__':
    test_cases = [
        ("Stable: s^3 + 6s^2 + 11s + 6", [1, 6, 11, 6]),
        ("Unstable: s^3 - 6s^2 + 11s - 6", [1, -6, 11, -6]),
        # ("Marginally Stable (jw-axis, Row of Zeros): s^3 + s^2 + s + 1", [1, 1, 1, 1]),
        # ("Marginally Stable (jw-axis, Row of Zeros): s^2 + 1", [1, 0, 1]),
        # ("Marginally Stable (epsilon case): s^3 + 2s^2 + s + 2", [1, 2, 1, 2]),
        # ("Unstable (row of zeros & RHP): s^5 + 2s^4 + 3s^3 + 6s^2 + 5s + 10", [1, 2, 3, 6, 5, 10]),
        # ("Stable: s + 1", [1, 1]),
        # ("Stable: s^2 + 2s + 1", [1, 2, 1]),
        # ("Unstable: s^2 - 1", [1, 0, -1]),
        # ("Marginally Stable (all jw-axis): s^4 + 3s^2 + 2", [1, 0, 3, 0, 2]),
        # ("All Zero Coefficients", [0, 0, 0]),
        # ("Single Zero Coefficient", [0]),
        # ("Single Non-Zero Coefficient (Stable)", [5]),
        # ("Leading Zeros: 0s^3 + s^2 + 2s + 1", [0, 1, 2, 1]),
        # ("Unstable (2 RHP): s^4 - s^3 - 7s^2 + s + 6", [1, -1, -7, 1, 6]),
        # ("Marginally Stable (Ogata Example): s^6+2s^5+8s^4+12s^3+20s^2+16s+16", [1, 2, 8, 12, 20, 16, 16]),
        # ("Marginally Stable (User Example): s^5+s^4+2s^3+2s^2+s+1", [1, 1, 2, 2, 1, 1]),
        # ("Simplest s", [1, 0]),  # s=0 -> one pole at origin (marginally stable)
        # ("Order 0: constant", [10]),  # Stable
        # ("Order 0: zero", [0]),  # Unstable
        # ("Test case leading to problems with aux poly (constant aux poly)", [1, 1, 0, 0]),
        # s^3+s^2. R1=[1,0], R2=[1,0]. R3=aux from s^2. dA/ds = 2s. R3=[2,0]. R4=0. R4 gets eps.
    ]

    show_all_roots_main = True

    for desc, coeffs_main in test_cases:
        print(f"--- Testing Case: {desc} ---")
        try:
            rh_table_res, unstable_poles_res, is_stable_res, message_res = routh_hurwitz(coeffs_main)
            print_routh_details(str(coeffs_main), rh_table_res, unstable_poles_res, is_stable_res, message_res,
                                show_roots_opt=show_all_roots_main, original_coeffs_in=coeffs_main)
        except Exception as e:
            print(f"Error during Routh-Hurwitz calculation for {coeffs_main}: {e}")
            # Optionally, try to print roots even if Routh failed
            if show_all_roots_main:
                print_routh_details(str(coeffs_main), None, -1, False, "Routh calc failed.",
                                    show_roots_opt=True, original_coeffs_in=coeffs_main)
        print("-" * 50)

    # # Interactive input part
    # print("\n--- Interactive Test ---")
    # try:
    #     coeff_str_user = input("Input vector of your system coefficients (space-separated, e.g., 1 6 11 6): \n")
    #     user_coeffs_list = [float(c) for c in coeff_str_user.split()]
    #
    #     rh_table_usr, unstable_poles_usr, is_stable_usr, message_usr = routh_hurwitz(user_coeffs_list)
    #     print_routh_details(str(user_coeffs_list), rh_table_usr, unstable_poles_usr, is_stable_usr, message_usr,
    #                         show_roots_opt=False, original_coeffs_in=user_coeffs_list)
    #
    #     reply_roots = input('Do you want roots of system to be shown? Y/N: ')
    #     if reply_roots.lower() == 'y':
    #         # Re-call print_routh_details with show_roots_opt=True using already computed results
    #         print_routh_details(str(user_coeffs_list), rh_table_usr, unstable_poles_usr, is_stable_usr, message_usr,
    #                             show_roots_opt=True, original_coeffs_in=user_coeffs_list)
    #
    #
    # except ValueError:
    #     print("Invalid input. Please enter space-separated numbers.")
    # except Exception as e:
    #     print(f"An error occurred: {e}")
