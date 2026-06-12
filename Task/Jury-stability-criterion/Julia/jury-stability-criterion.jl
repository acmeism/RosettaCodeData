using Polynomials

""" Performs the three necessary conditions (sufficient for n<=2) """
function my_test3(P_coeffs, n_order)
    # 1. P(z=1) > 0
    val_at_1 = evalpoly(1, reverse(P_coeffs))
    test1 = (val_at_1 > 1e-9)  # Numerically robust check for > 0
    println("\t       P(z = 1)  > 0       =>   $(r4(val_at_1)) > 0     => $(("FALSE", "TRUE ")[test1 + 1])")

    # 2. (-1)^n * P(z=-1) > 0
    val_at_minus_1 = evalpoly(-1, reverse(P_coeffs))
    term_with_n = (-1)^n_order * val_at_minus_1
    test2 = (term_with_n > 1e-9)  # Numerically robust check for > 0
    println("\t (-1)ⁿ  P(z = -1) > 0      =>   $(r4(term_with_n)) > 0     => $(("FALSE", "TRUE ")[test2 + 1])")

    # 3. |an| > |a0|
    an = P_coeffs[begin]
    a0 = P_coeffs[end]  # a0 is the last coefficient
    test3_cond = (abs(an) > abs(a0))
    # Ensure an is not zero for this condition if poly order is > 0
    if n_order > 0 && abs(an) < 1e-9  # an is effectively zero
        # This case indicates a lower order polynomial or problem with input.
        # Original MATLAB doesn"t explicitly check an!=0 here but Jury assumes it.
        # For robustness, if an is zero, this test usually implies instability or undefined.
        # However, if a0 is also zero, |0| > |0| is false.
        # Let the direct comparison proceed as per MATLAB
    end
    println("\t            |an| > |a0|    => |$(r4(an))| > |$(r4(a0))| => $(("FALSE", "TRUE ")[test3_cond + 1])")

    return test1 && test2 && test3_cond
end

""" Constructs the Jury table """
function jury_table_py(P_coeffs, n_order)
    num_coeffs = n_order + 1
    # This function is called only if n_order > 2 in the MATLAB code
    # For n_order = 3, rows = 2*3 - 3 = 3 (indices 0, 1, 2)
    # For n_order = 4, rows = 2*4 - 3 = 5 (indices 0, 1, 2, 3, 4)
    T = zeros(2 * n_order - 3, num_coeffs)

    # First two rows (Python 0-indexed)
    T[1, :] .= reverse(P_coeffs)  # P_coeffs reversed (a0, a1, ..., an)
    T[2, :] .= P_coeffs  # P_coeffs (an, an-1, ..., a0)

    # Third row (Python T[2,:]) - first derived row
    # Corresponds to MATLAB"s T(3,:) = T(1,1)*T(1,:) - T(2,1)*T(2,:)
    T[3, :] = T[1, 1] * T[1, :] - T[2, 1] * T[2, :]

    # Loop for subsequent rows (if n_order > 3)
    # MATLAB loop: for (j=2:(n-2))
    # Python equivalent: for j_matlab in range(2, n_order - 2 + 1)
    # (n_order - 2) is the upper limit for j_matlab (inclusive)
    for j_m in 2:n_order-2  # Corrected range for j_matlab values 2, ..., n_order-2
        # Python indices for T:
        idx_prev_main_row_py = (2 * j_m - 1)  # Corresponds to T_matlab(2*j_m-1, :)
        idx_new_even_row_py = (2 * j_m)  # Corresponds to T_matlab(2*j_m, :)
        idx_new_main_row_py = (2 * j_m + 1)  # Corresponds to T_matlab(2*j_m+1, :)

        # MATLAB: T(2*j,1:c-1)=fliplr(T(2*j-1,1:c-1)); where c-1 is n_order (original order)
        # This means it always considers the first n_order elements for flipping.
        # The "effective" polynomial length decreases, but the slice is on the padded row.
        slice_len_for_flip = n_order  # num_coeffs - 1

        source_for_flip = T[idx_prev_main_row_py, begin:slice_len_for_flip]
        T[idx_new_even_row_py, begin:slice_len_for_flip] .= reverse(source_for_flip)

        # T(2*j+1,:)=T(2*j-1,1) * T(2*j-1,:) - T(2*j,1)* T(2*j,:);
        T[idx_new_main_row_py, :] .= (T[idx_prev_main_row_py, begin] .* T[idx_prev_main_row_py, :] .-
                                      T[idx_new_even_row_py, begin] .* T[idx_new_even_row_py, :])
    end
    return T
end

""" Prints the Jury table """
function print_jury_table_py(T, n_order)
    num_total_cols = n_order + 1  # Max number of coefficients displayed initially
    print("   Row\t\t| Table\n")

    # Loop for main table body (pairs of rows)
    # MATLAB i from 0 to n-3 (inclusive)
    # (n_order - 3) - 0 + 1 = n_order - 2 iterations
    for i_loop in 0:n_order-3
        row1_idx = i_loop * 2 + 1
        row2_idx = row1_idx + 1

        # Number of elements to print in this pair of rows (decreases)
        num_elements_to_print = num_total_cols - i_loop

        print("\t$(n_order - i_loop)\t| ")  # Row `order` label
        for j_col_py in 1:num_elements_to_print
            print("\t$(r4(T[row1_idx, j_col_py]))")
        end
        println()

        print("\t\t| ")
        for j_col_py in 1:num_elements_to_print
            print("\t$(r4(T[row2_idx, j_col_py]))")
        end
        println()

        print("\t-------")
        for _ in 1:num_elements_to_print
            print("\t-------")
        end
        println("---")
    end
    # Print the last "main" row relevant for testing (order 2 polynomial coeffs)
    # This is T_matlab((n-2)*2 + 1, :) which has 3 effective elements (c2, c1, c0)
    last_main_row = (n_order - 2) * 2 + 1

    print("\t2\t| ")  # Label for this row is "2" (for order 2 poly)
    for j_col in 1:3  # Print first 3 elements: c2, c1, c0
        if j_col < size(T, 2)  # Check bounds, T should have at least 3 cols
            print("\t$(r4(T[last_main_row, j_col]))")
        end
    end
    println("\n")
end

""" Performs additional n-2 tests using the Jury table """
function add_test_py(T, n_order)
    stability = true

    # MATLAB loop i from 1 to n-2
    for i_m_loop in 1:n_order-2
        # riga_py = T_matlab(2*i+1, :) row index
        riga = 2 * i_m_loop + 1
        # ultima_colonna_py = T_matlab(riga, n+1-i) column index (0-based)
        # The polynomial at row "riga_py" has order n_order - i_m_loop.
        # Its coefficients are c_{n-i}, ..., c_0.
        # First coeff is T[riga_py, 0].
        # Last coeff c_0 is at index (n_order - i_m_loop).
        idx_last_coeff = n_order - i_m_loop + 1

        val_first = T[riga, begin]
        val_last = T[riga, idx_last_coeff]

        current_test = abs(val_first) > abs(val_last)

        # Added newline from matlab code \n
        println("\t| $(r4(val_first)) | > | $(r4(val_last)) |\t=> $(("FALSE", "TRUE ")[current_test + 1])")

        stability &= current_test
    end

    return stability
end

""" Prints roots of the polynomial """
function print_roots_py(P_coeffs)
    if length(P_coeffs) <= 1 && ((length(P_coeffs) == 0 || P_coeffs[begin] == 0))
        println("\t Polynomial is zero or empty, roots are undefined or infinite.")
        return
    end
    if length(P_coeffs) == 1  # Constant P = [c] (c!=0)
        println("\t Polynomial is a non-zero constant, no roots.")
        return
    end
    # Check if leading coefficient is zero, which means polynomial order is effectively lower
    actual_poly = Polynomial(reverse(P_coeffs))
    if actual_poly.coeffs == [0] # All zeros
        print("\t Polynomial is all zeros, roots are undefined.")
        return
    elseif length(actual_poly.coeffs) == 1  # Reduced to a constant
        print("\t Polynomial reduced to a non-zero constant, no roots.")
        return
    end
    calculated_roots = roots(actual_poly)

    for (i, r_val) in enumerate(calculated_roots)
        modulus = abs(r_val)
        r_real = real(r_val)
        r_imag = imag(r_val)

        if abs(r_imag) < 1e-9  # Treat as real
            println("\t z{i + 1} = $(r4(r_real)) \t=> modulus = $(r4(modulus))")
        else
            sign = r_imag >= 0 ? "+" : ""  # MATLAB code has " for negative imag
            println("\t z$i = $(r4(r_real)) $sign$(r4(r_imag)) i\t=> modulus = $(r4(modulus))")
        end
    end
end

""" Main Jury criterion function """
function jury_c(P_in::Vector)
    P_coeffs_orig = Float64.(P_in)

    # Remove leading zeros, as Jury criterion assumes an != 0
    P_coeffs = reverse(Polynomial(reverse(P_coeffs_orig)).coeffs)
    if P_coeffs == [0] # All zeros
        println("\n\nInput error: Polynomial is all zeros.")
        return nothing
    elseif length(P_coeffs) == 1  # Reduced to a constant
        print("\n\nInput error or trivial case: Polynomial order is < 1 (P=$P_coeffs).")
        print("Jury criterion is for order >= 1.")
        # Optionally, one could analyze stability for order 0: P(z)=a0. Stable if |a0|<something related to context?
        # For discrete systems, a single pole at z=a0 needs |a0|<1. But Jury is for P(z)=0.
        # Here P(z) is the characteristic polynomial. If order 0, it"s a constant, means no dynamics or 0 roots.
        # The MATLAB code expects len(P) >= 2 (order >= 1)
        return nothing
    end

    println("\n", '*'^60, "\n\tPolynomial under test: ")
    print_poly_py(P_coeffs)

    if P_coeffs[begin] < 0
        P_coeffs = P_coeffs .* -1.0  # Ensure an > 0
    end

    n_order = length(P_coeffs) - 1
    T_table = nothing
    stability_flag = false

    if n_order <= 2
        println("\nPolynomial order = $n_order SO THEN")
        println("necessary and sufficient conditions:")
        stability_flag = my_test3(P_coeffs, n_order)
        println(stability_flag ? "\tThe system is stable. The roots are:" :
                "\t*** The system IS NOT STABLE ***.\nThe roots are:")
    else
        println("\nPolynomial order = $n_order")
        println("necessary conditions:")
        stability_flag = my_test3(P_coeffs, n_order)
        if stability_flag
            println("The necessary conditions are met.\n")
            println("Jury table:")

            T_table = jury_table_py(P_coeffs, n_order)
            print_jury_table_py(T_table, n_order)

            print("\tAdditional condition(s) to test = $(n_order - 2)\n")
            stability_flag = add_test_py(T_table, n_order)

            if stability_flag
                print("\nThe system is stable. The roots are:\n")
            else
                print("\n*** The system IS NOT STABLE ***. \n\nThe roots are:\n")
            end
        else
            print("\n*** The system IS NOT STABLE because the necessary conditions are not met***. \n\nThe roots are:\n")
        end
    end
    print_roots_py(P_coeffs)  # Print roots of the (potentially sign-normalized) polynomial
    return T_table
end

r4(x) = round(x, sigdigits = 4)
print_poly_py(arr) = println(Polynomial(reverse(arr)))

""" Main script execution part """
function test_jury_stability()
    # Test case 1: [a3 a2 a1 a0]
    print("-------------------- Test Case 1 --------------------")
    jury_c([1, 3.3, 4, 0.8])

    # print("\n\n\n********** > press a key to continue")
    # input()  # Python"s equivalent of pause

    # Test case 2: [a4 a3 a2 a1 a0]
    print("\n-------------------- Test Case 2 --------------------")
    jury_c([1, 1.4, 0.71, 0.154, 0.012])

    # Additional test cases for print_poly_py
    println("\n\n----- print_poly_py Test Cases -----\n")
    print_poly_py([1.0, 0.0, -2.0, 0.0, 5.0])  # z^4 - 2z^2 + 5
    print_poly_py([1.0, 1.0, 1.0])  # z^2 + z + 1
    print_poly_py([-1.0, 2.5, -3.0])  # -z^2 + 2.5z - 3 (will be normalized by jury_c)
    print_poly_py([0.0, 0.0, 1.0, 2.0, 0.0])  # z^2 + 2z (after trim_zeros in jury_c)
    print_poly_py([5.0])  # Constant
    print_poly_py([0.0])  # Zero polynomial
    print_poly_py([0.0, 0.0, 0.0])  # Zero polynomial
end

test_jury_stability()
