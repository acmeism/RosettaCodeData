import numpy as np

# Helper function to evaluate polynomial
def eval_poly(P_coeffs, z):
    """
    Evaluates the polynomial P_coeffs at a given value z.
    P_coeffs = [an, an-1, ..., a0]
    """
    return np.polyval(P_coeffs, z)


# Helper function to print polynomial in two lines (exponents above)
# This attempts to replicate MATLAB's two-line polynomial printing.
# Exact alignment can be tricky due to font differences and tab handling.
def print_poly_py(P_coeffs_orig):
    P_coeffs = np.array(P_coeffs_orig, dtype=float)
    n_order = len(P_coeffs) - 1

    base_parts = []
    exp_parts = []
    first_term_processed = False

    if n_order == -1:  # Empty P_coeffs
        print("\tError: Polynomial is empty.")
        return -1

    for i, coeff in enumerate(P_coeffs):
        power = n_order - i

        term_base_str = ""
        term_exp_str = ""

        # Skip zero coefficients unless it's the only term or explicitly needed
        if coeff == 0.0:
            if n_order == 0 and i == 0:  # P = [0]
                term_base_str = f"{0:.3g}"
                term_exp_str = " "  # Corresponding space for exponent
            elif not first_term_processed and not np.any(P_coeffs[i:]):  # All remaining are zero e.g. P=[0,0,0]
                term_base_str = f"{0:.3g}"
                term_exp_str = " "
                base_parts.append(term_base_str)
                exp_parts.append(term_exp_str)
                first_term_processed = True  # Mark that we printed something
                break  # Stop after printing a single "0" for an all-zero poly
            elif first_term_processed and power == 0:  # If it's a constant 0 at the end of non-zero poly
                term_base_str += f" + {abs(coeff):.3g}"  # e.g. z + 0
                term_exp_str = " " * len(term_base_str)
            else:  # Intermediate zero or leading zero before other terms
                continue
        else:  # Non-zero coefficient
            # Sign
            if coeff < 0:
                term_base_str += "-" if not first_term_processed else " - "
            elif first_term_processed:  # Positive coeff, not the first term
                term_base_str += " + "

            abs_coeff = abs(coeff)

            # Coefficient
            if abs_coeff != 1.0 or power == 0:
                term_base_str += f"{abs_coeff:.3g}"

            # Variable and exponent
            if power > 0:
                if term_base_str and term_base_str[-1] not in [' ', '-'] and (
                        abs_coeff != 1.0 or not term_base_str.endswith(
                        str(int(abs_coeff)))):  # Add space: "2.5 z" vs "z"
                    if abs_coeff != 1.0: term_base_str += " "
                term_base_str += "z"
                if power > 1:
                    # Align exponent over 'z'
                    # Find 'z', then pad exponent string
                    z_pos_in_term = term_base_str.rfind('z')
                    exp_val_str = str(power)
                    # Create exp string for this term, aligned with term_base_str
                    term_exp_str = ' ' * z_pos_in_term + exp_val_str
                else:  # power is 1
                    term_exp_str = ""  # No exponent displayed for z^1
            else:  # power is 0 (constant term)
                term_exp_str = ""

                # Ensure term_exp_str is same length as term_base_str by padding
        term_exp_str = term_exp_str.ljust(len(term_base_str))

        base_parts.append(term_base_str)
        exp_parts.append(term_exp_str)
        first_term_processed = True

    if not first_term_processed:  # Handles P=[] or if logic above fails for P=[0,0]
        if len(P_coeffs) > 0 and np.all(P_coeffs == 0):  # All zeros like P=[0,0]
            base_parts.append(f"{0:.3g}")
            exp_parts.append(" ")
        elif not P_coeffs.any():  # P_coeffs is empty or all zeros
            base_parts.append(f"{0:.3g}")  # Default to "0"
            exp_parts.append(" ")

    print(f"\t{''.join(exp_parts)}")
    print(f"\t{''.join(base_parts)}")
    return n_order


# Performs the three necessary conditions (sufficient for n<=2)
def my_test3(P_coeffs, n_order):
    stability = True

    # 1. P(z=1) > 0
    val_at_1 = eval_poly(P_coeffs, 1)
    test1 = (val_at_1 > 1e-9)  # Numerically robust check for > 0
    print(f"\t       P(z = 1)  > 0       =>   {val_at_1:9.3g} > 0     => {('FALSE', 'TRUE ')[test1]}")
    if not test1:
        stability = False

    # 2. (-1)^n * P(z=-1) > 0
    val_at_minus_1 = eval_poly(P_coeffs, -1)
    term_with_n = ((-1) ** n_order) * val_at_minus_1
    test2 = (term_with_n > 1e-9)  # Numerically robust check for > 0
    print(f"\t     n ")
    print(f"\t (-1)  P(z = -1) > 0       =>   {term_with_n:9.3g} > 0     => {('FALSE', 'TRUE ')[test2]}\n")
    if not test2:
        stability = False

    # 3. |an| > |a0|
    an = P_coeffs[0]
    a0 = P_coeffs[-1]  # a0 is the last coefficient
    test3_cond = (abs(an) > abs(a0))
    # Ensure an is not zero for this condition if poly order is > 0
    if n_order > 0 and abs(an) < 1e-9:  # an is effectively zero
        # This case indicates a lower order polynomial or problem with input.
        # Original MATLAB doesn't explicitly check an!=0 here but Jury assumes it.
        # For robustness, if an is zero, this test usually implies instability or undefined.
        # However, if a0 is also zero, |0| > |0| is false.
        pass  # Let the direct comparison proceed as per MATLAB

    print(f"\t            |an| > |a0|    => |{an:9.3g}| > |{a0:9.3g}|   => {('FALSE', 'TRUE ')[test3_cond]}")
    if not test3_cond:
        stability = False

    return stability


# Constructs the Jury table
def jury_table_py(P_coeffs, n_order):
    num_coeffs = n_order + 1
    # This function is called only if n_order > 2 in the MATLAB code
    # For n_order = 3, rows = 2*3 - 3 = 3 (indices 0, 1, 2)
    # For n_order = 4, rows = 2*4 - 3 = 5 (indices 0, 1, 2, 3, 4)
    T = np.zeros((2 * n_order - 3, num_coeffs))

    # First two rows (Python 0-indexed)
    T[0, :] = P_coeffs[::-1]  # P_coeffs reversed (a0, a1, ..., an)
    T[1, :] = P_coeffs  # P_coeffs (an, an-1, ..., a0)

    # Third row (Python T[2,:]) - first derived row
    # Corresponds to MATLAB's T(3,:) = T(1,1)*T(1,:) - T(2,1)*T(2,:)
    T[2, :] = T[0, 0] * T[0, :] - T[1, 0] * T[1, :]

    # Loop for subsequent rows (if n_order > 3)
    # MATLAB loop: for (j=2:(n-2))
    # Python equivalent: for j_matlab in range(2, n_order - 2 + 1)
    # (n_order - 2) is the upper limit for j_matlab (inclusive)
    for j_m in range(2, n_order - 1):  # Corrected range for j_matlab values 2, ..., n_order-2
        # Python indices for T:
        idx_prev_main_row_py = (2 * j_m - 1) - 1  # Corresponds to T_matlab(2*j_m-1, :)
        idx_new_even_row_py = (2 * j_m) - 1  # Corresponds to T_matlab(2*j_m, :)
        idx_new_main_row_py = (2 * j_m + 1) - 1  # Corresponds to T_matlab(2*j_m+1, :)

        # MATLAB: T(2*j,1:c-1)=fliplr(T(2*j-1,1:c-1)); where c-1 is n_order (original order)
        # This means it always considers the first n_order elements for flipping.
        # The "effective" polynomial length decreases, but the slice is on the padded row.
        slice_len_for_flip = n_order  # num_coeffs - 1

        source_for_flip = T[idx_prev_main_row_py, 0:slice_len_for_flip]
        T[idx_new_even_row_py, 0:slice_len_for_flip] = np.flip(source_for_flip)

        # T(2*j+1,:)=T(2*j-1,1) * T(2*j-1,:) - T(2*j,1)* T(2*j,:);
        T[idx_new_main_row_py, :] = (T[idx_prev_main_row_py, 0] * T[idx_prev_main_row_py, :] -
                                     T[idx_new_even_row_py, 0] * T[idx_new_even_row_py, :])
    return T


# Prints the Jury table
def print_jury_table_py(T, n_order):
    num_total_cols = n_order + 1  # Max number of coefficients displayed initially
    print('   Row\t\t Table\n')

    # Loop for main table body (pairs of rows)
    # MATLAB i from 0 to n-3 (inclusive)
    # (n_order - 3) - 0 + 1 = n_order - 2 iterations
    for i_loop in range(n_order - 2):
        row1_idx_py = i_loop * 2
        row2_idx_py = i_loop * 2 + 1

        # Number of elements to print in this pair of rows (decreases)
        num_elements_to_print = num_total_cols - i_loop

        print(f"\t{n_order - i_loop}\t| ", end="")  # Row "order" label
        for j_col_py in range(num_elements_to_print):
            print(f"\t{T[row1_idx_py, j_col_py]:6.3g}", end="")
        print('\n')

        print(f"\t\t| ", end="")
        for j_col_py in range(num_elements_to_print):
            print(f"\t{T[row2_idx_py, j_col_py]:6.3g}", end="")
        print('\n')

        print(f"\t-------", end="")
        for _ in range(num_elements_to_print):
            print(f"\t-------", end="")
        print('---\n')

    # Print the last "main" row relevant for testing (order 2 polynomial coeffs)
    # This is T_matlab((n-2)*2 + 1, :) which has 3 effective elements (c2, c1, c0)
    last_main_row_py_idx = (n_order - 2) * 2

    print(f"\t{2}\t| ", end="")  # Label for this row is '2' (for order 2 poly)
    for j_col_py in range(3):  # Print first 3 elements: c2, c1, c0
        if j_col_py < T.shape[1]:  # Check bounds, T should have at least 3 cols
            print(f"\t{T[last_main_row_py_idx, j_col_py]:6.3g}", end="")
    print('\t\n\n\n')


# Performs additional n-2 tests using the Jury table
def add_test_py(T, n_order):
    stability = True

    # MATLAB loop i from 1 to n-2
    for i_m_loop in range(1, n_order - 2 + 1):
        # riga_py = T_matlab(2*i+1, :) row index
        riga_py = (2 * i_m_loop + 1) - 1

        # ultima_colonna_py = T_matlab(riga, n+1-i) column index (0-based)
        # The polynomial at row 'riga_py' has order n_order - i_m_loop.
        # Its coefficients are c_{n-i}, ..., c_0.
        # First coeff is T[riga_py, 0].
        # Last coeff c_0 is at index (n_order - i_m_loop).
        idx_last_coeff_py = n_order - i_m_loop

        val_first = T[riga_py, 0]
        val_last = T[riga_py, idx_last_coeff_py]

        current_test = (abs(val_first) > abs(val_last))

        print(
            f"\t| {val_first:9.3g} | > | {val_last:9.3g} | \t\t => {('FALSE', 'TRUE ')[current_test]}")  # Added newline from matlab code \n
        if not current_test:
            stability = False

    return stability


# Prints roots of the polynomial
def print_roots_py(P_coeffs):
    if len(P_coeffs) <= 1 and (len(P_coeffs) == 0 or P_coeffs[0] == 0):
        print("\t Polynomial is zero or empty, roots are undefined or infinite.")
        return
    if len(P_coeffs) == 1:  # Constant P = [c] (c!=0)
        print("\t Polynomial is a non-zero constant, no roots.")
        return

    # Check if leading coefficient is zero, which means polynomial order is effectively lower
    actual_coeffs = np.trim_zeros(P_coeffs, 'f')
    if len(actual_coeffs) == 0:  # All zeros
        print("\t Polynomial is all zeros, roots are undefined.")
        return
    if len(actual_coeffs) == 1:  # Reduced to a constant
        print("\t Polynomial reduced to a non-zero constant, no roots.")
        return

    calculated_roots = np.roots(actual_coeffs)

    for i, r_val in enumerate(calculated_roots):
        modulus = np.abs(r_val)
        r_real = r_val.real
        r_imag = r_val.imag

        if abs(r_imag) < 1e-9:  # Treat as real
            print(f"\t z{i + 1} = {r_real:7.3f} \t\t\t\t\t=> modulus = {modulus:7.3f}")
        else:
            sign = '+' if r_imag >= 0 else ''  # MATLAB code has '' for negative imag
            print(f"\t z{i + 1} = {r_real:7.3f} {sign}{r_imag:7.3f} i\t\t\t=> modulus = {modulus:7.3f}")


# Main Jury criterion function
def jury_c(P_in):
    # Input argument validation
    if not isinstance(P_in, (list, np.ndarray)):
        print('\n\nInput error. P must be a list or numpy array.')
        print('\tjury_c([an, an-1, ..., a1, a0])')
        return None

    P_coeffs_orig = np.array(P_in, dtype=float)

    if P_coeffs_orig.ndim != 1 or len(P_coeffs_orig) == 0:
        print('\n\nInput error. P must be a 1D array/list.')
        print('\tjury_c([an, an-1, ..., a1, a0])')
        return None

    # Remove leading zeros, as Jury criterion assumes an != 0
    P_coeffs = np.trim_zeros(P_coeffs_orig, 'f')
    if len(P_coeffs) == 0:  # All zeros originally
        print("\n\nInput error: Polynomial is all zeros.")
        return None
    if len(P_coeffs) < 2:  # Constant polynomial [a0] or reduced to it
        print(f"\n\nInput error or trivial case: Polynomial order is < 1 (P={P_coeffs}).")
        print("Jury criterion is for order >= 1.")
        # Optionally, one could analyze stability for order 0: P(z)=a0. Stable if |a0|<something related to context?
        # For discrete systems, a single pole at z=a0 needs |a0|<1. But Jury is for P(z)=0.
        # Here P(z) is the characteristic polynomial. If order 0, it's a constant, means no dynamics or 0 roots.
        # The MATLAB code expects len(P) >= 2 (order >= 1)
        return None

    print('\n*****************************************')
    print('\tPolynomial under test:\n')

    if P_coeffs[0] < 0:
        P_coeffs = P_coeffs * -1.0  # Ensure an > 0

    n_order = print_poly_py(P_coeffs)
    # n_order = len(P_coeffs) - 1 # If print_poly_py does not return it

    T_table = None
    stability_flag = False

    if n_order <= 2:
        print(f'\n\nPolynomial order = {n_order} THEN\n')
        print('necessary and sufficient conditions:\n')
        stability_flag = my_test3(P_coeffs, n_order)
        if stability_flag:
            print('\nThe system is stable. The roots are:')
        else:
            print('\n*** The system IS NOT STABLE ***. \n\nThe roots are:\n')
    else:  # n_order > 2
        print(f'\n\nPolynomial order = {n_order} \n\n')
        print('necessary conditions:\n')
        stability_flag = my_test3(P_coeffs, n_order)

        if stability_flag:
            print('\nThe necessary conditions are met. \n')
            print('It is necessary to build the Jury table.\n')

            T_table = jury_table_py(P_coeffs, n_order)
            print_jury_table_py(T_table, n_order)

            print(f'\t\tAdditional condition to test = {n_order - 2} \n')
            stability_flag = add_test_py(T_table, n_order)

            if stability_flag:
                print('\nThe system is stable. The roots are:\n')
            else:
                print('\n*** The system IS NOT STABLE ***. \n\nThe roots are:\n')
        else:
            print(
                '\n*** The system IS NOT STABLE because the necessary conditions are not met***. \n\nThe roots are:\n')

    print_roots_py(P_coeffs)  # Print roots of the (potentially sign-normalized) polynomial

    return T_table


# Main script execution part
if __name__ == "__main__":
    # Test case 1: [a3 a2 a1 a0]
    print("--- Test Case 1 ---")
    jury_c([1, 3.3, 4, 0.8])

    # print('\n\n\n********** > press a key to continue')
    # input()  # Python's equivalent of pause

    # Test case 2: [a4 a3 a2 a1 a0]
    print("\n--- Test Case 2 ---")
    jury_c([1, 1.4, 0.71, 0.154, 0.012])

    # Additional test cases for print_poly_py
    print("\n--- print_poly_py Test Cases ---")
    print_poly_py(np.array([1., 0., -2., 0., 5.]))  # z^4 - 2z^2 + 5
    print_poly_py(np.array([1., 1., 1.]))  # z^2 + z + 1
    print_poly_py(np.array([-1., 2.5, -3.]))  # -z^2 + 2.5z - 3 (will be normalized by jury_c)
    print_poly_py(np.array([0., 0., 1., 2., 0.]))  # z^2 + 2z (after trim_zeros in jury_c)
    print_poly_py(np.array([5.]))  # Constant
    print_poly_py(np.array([0.]))  # Zero polynomial
    print_poly_py(np.array([0., 0., 0.]))  # Zero polynomial
