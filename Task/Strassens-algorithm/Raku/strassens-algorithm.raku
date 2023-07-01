# 20210126 Raku programming solution

use Math::Libgsl::Constants;
use Math::Libgsl::Matrix;
use Math::Libgsl::BLAS;

my @M;

sub SQM (\in) { # create custom sq matrix from CSV
   die "Not a ■" if (my \L = in.split(/\,/)).sqrt != (my \size = L.sqrt.Int);
   my Math::Libgsl::Matrix \M .= new: size, size;
   for ^size Z L.rotor(size) -> ($i, @row) { M.set-row: $i, @row }
   M
}

sub infix:<⊗>(\x,\y) { # custom multiplication
   my Math::Libgsl::Matrix \z .= new: x.size1, x.size2;
   dgemm(CblasNoTrans, CblasNoTrans, 1, x, y, 1, z);
   z
}

sub infix:<⊕>(\x,\y) { # custom addition
   my Math::Libgsl::Matrix \z .= new: x.size1, x.size2;
   z.copy(x).add(y)
}

sub infix:<⊖>(\x,\y) { # custom subtraction
   my Math::Libgsl::Matrix \z .= new: x.size1, x.size2;
   z.copy(x).sub(y)
}

sub Strassen($A, $B) {

   { return $A ⊗ $B } if (my \n = $A.size1) == 1;

   my Math::Libgsl::Matrix        ($A11,$A12,$A21,$A22,$B11,$B12,$B21,$B22);
   my Math::Libgsl::Matrix        ($P1,$P2,$P3,$P4,$P5,$P6,$P7);
   my Math::Libgsl::Matrix::View  ($mv1,$mv2,$mv3,$mv4,$mv5,$mv6,$mv7,$mv8);
   ($mv1,$mv2,$mv3,$mv4,$mv5,$mv6,$mv7,$mv8)».=new ;

   my \half = n div 2; # dimension of quarter submatrices

   $A11 = $mv1.submatrix($A, 0,0,       half,half); #
   $A12 = $mv2.submatrix($A, 0,half,    half,half); #  create quarter views
   $A21 = $mv3.submatrix($A, half,0,    half,half); #  of operand matrices
   $A22 = $mv4.submatrix($A, half,half, half,half); #
   $B11 = $mv5.submatrix($B, 0,0,       half,half); #       11    12
   $B12 = $mv6.submatrix($B, 0,half,    half,half); #
   $B21 = $mv7.submatrix($B, half,0,    half,half); #       21    22
   $B22 = $mv8.submatrix($B, half,half, half,half); #

   $P1 = Strassen($A12 ⊖ $A22, $B21 ⊕ $B22);
   $P2 = Strassen($A11 ⊕ $A22, $B11 ⊕ $B22);
   $P3 = Strassen($A11 ⊖ $A21, $B11 ⊕ $B12);
   $P4 = Strassen($A11 ⊕ $A12, $B22        );
   $P5 = Strassen($A11,         $B12 ⊖ $B22);
   $P6 = Strassen($A22,         $B21 ⊖ $B11);
   $P7 = Strassen($A21 ⊕ $A22, $B11        );

   my Math::Libgsl::Matrix        $C .= new: n, n;               # Build C from
   my Math::Libgsl::Matrix::View  ($mvC11,$mvC12,$mvC21,$mvC22); #    C11 C12
   ($mvC11,$mvC12,$mvC21,$mvC22)».=new ;                         #    C21 C22

   given $mvC11.submatrix($C, 0,0,       half,half) { .add: (($P1 ⊕ $P2) ⊖ $P4) ⊕ $P6 };
   given $mvC12.submatrix($C, 0,half,    half,half) { .add:   $P4 ⊕ $P5 };
   given $mvC21.submatrix($C, half,0,    half,half) { .add:   $P6 ⊕ $P7 };
   given $mvC22.submatrix($C, half,half, half,half) { .add: (($P2 ⊖ $P3) ⊕ $P5) ⊖ $P7 };

   $C
}

for $=pod[0].contents { next if /^\n$/ ; @M.append: SQM $_ }

for @M.rotor(2) {
   my $product = @_[0] ⊗ @_[1];
#   $product.get-row($_)».round(1).fmt('%2d').put for ^$product.size1;

   say "Regular multiply:";
   $product.get-row($_)».fmt('%.10g').put for ^$product.size1;

   $product = Strassen @_[0], @_[1];

   say "Strassen multiply:";
   $product.get-row($_)».fmt('%.10g').put for ^$product.size1;
}

=begin code
1,2,3,4
5,6,7,8
1,1,1,1,2,4,8,16,3,9,27,81,4,16,64,256
4,-3,4/3,-1/4,-13/3,19/4,-7/3,11/24,3/2,-2,7/6,-1/4,-1/6,1/4,-1/6,1/24
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1
=end code
