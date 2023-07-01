solve:{[A;B] $[0h>type A;B%A;inv[A] mmu B]}
ak:{[m;k] (),/:m[;k]til k:k-1}
akk:{[m;k] m[k;k:k-1]}
transpose:{$[0h=type x;flip x;enlist each x]}
mult:{[A;B]$[0h=type A;A mmu B;A*B]}		
cholesky:{[A]
	{[A;L;n]
		l_k:solve[L;ak[A;n]];
		l_kk:first over sqrt[akk[A;n] - mult[transpose l_k;l_k]];
		({$[0h<type x;enlist x;x]}L,'0f),enlist raze transpose[l_k],l_kk
		}[A]/[sqrt A[0;0];1_1+til count first A]
	}

show cholesky (25 15 -5f;15 18 0f;-5 0 11f)
-1"";
show cholesky (18 22 54 42f;22 70 86 62f;54 86 174 134f;42 62 134 106f)
