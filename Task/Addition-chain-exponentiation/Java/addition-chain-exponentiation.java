import java.util.Arrays;

public class Main {

    // ==== toggle this if you want exact minimal chains (much slower) ====
    static final boolean FAST = true;

    static final int N = 32;
    static final int NMAX = 40000;

    static int[] u = new int[N], l = new int[N], out = new int[N], sum = new int[N], tail = new int[N];
    static int[] cache = new int[NMAX + 1];
    static int known = 2, stack = 0;

    static Save[] undo = new Save[N * N];
    static { u[0]=1; u[1]=2; l[0]=1; l[1]=2; cache[2]=1; for (int i=0;i<undo.length;i++) undo[i]=new Save(); }

    static final class IntBox { int value; IntBox(){} IntBox(int v){value=v;} }
    static final class Save { int[] arr; int idx; int val; }

    static void replace(int[] arr, int i, int n){ undo[stack].arr=arr; undo[stack].idx=i; undo[stack].val=arr[i]; arr[i]=n; stack++; }
    static void restore(int n){ while(stack>n){ Save s=undo[--stack]; s.arr[s.idx]=s.val; } }

    static int lower(int n, IntBox up){
        if (n<=2 || (n<=NMAX && cache[n]!=0)){ if (up!=null) up.value=cache[n]; return cache[n]; }
        int i=-1,o=0,tmp=n;
        for(;tmp!=0;tmp>>=1,i++) if((tmp&1)!=0)o++;
        if(up!=null){ i--; up.value=o+i; }
        while(true){ i++; o>>=1; if(o==0) break; }
        if(up==null) return i;
        for(int d=2; d*d<n; d++){
            if(n%d!=0) continue;
            int q = cache[d] + cache[n/d];
            if(q<up.value){ up.value=q; if(q==i) break; }
        }
        if(n>2){
            if(up.value > cache[n-1]+1) up.value=cache[n-1]+1;
            if(up.value > cache[n-2]+1) up.value=cache[n-2]+1;
        }
        return i;
    }

    static boolean insert(int x, int pos){
        int save=stack;
        if(l[pos]>x || u[pos]<x) return false;
        if(l[pos]!=x){
            replace(l,pos,x);
            for(int i=pos-1; i>=0 && u[i]*2<u[i+1]; i--){
                int t=l[i+1]+1; if(t*2>u[i]){ restore(save); return false; }
                replace(l,i,t);
            }
            for(int i=pos+1; i<N && l[i]<=l[i-1]; i++){
                int t=l[i-1]+1; if(t>u[i]){ restore(save); return false; }
                replace(l,i,t);
            }
        }
        if(u[pos]==x) return true;
        replace(u,pos,x);
        for(int i=pos-1; i>=0 && u[i]>=u[i+1]; i--){
            int t=u[i+1]-1; if(t<l[i]){ restore(save); return false; }
            replace(u,i,t);
        }
        for(int i=pos+1; i<N && u[i]>u[i-1]*2; i++){
            int t=u[i-1]*2; if(t<l[i]){ restore(save); return false; }
            replace(u,i,t);
        }
        return true;
    }

    static boolean tryPQ(int p,int q,int le){
        int pl=cache[p]; if(pl>=le) return false;
        int ql=cache[q]; if(ql>=le) return false;
        int pu,qu;
        while(pl<le && u[pl]<p) pl++;
        for(pu=pl-1; pu<le-1 && u[pu+1]>=p; pu++){}
        while(ql<le && u[ql]<q) ql++;
        for(qu=ql-1; qu<le-1 && u[qu+1]>=q; qu++){}
        if(p!=q && pl<=ql) pl=ql+1;
        if(pl>pu || ql>qu || ql>pu) return false;
        if(out[le]==0){ pu=le-1; pl=pu; }
        int ps=stack;
        for(; pu>=pl; pu--){
            if(!insert(p,pu)) continue;
            out[pu]++; sum[pu]+=le;
            if(p!=q){
                int qs=stack; int j=qu; if(j>=pu) j=pu-1;
                for(; j>=ql; j--){
                    if(!insert(q,j)) continue;
                    out[j]++; sum[j]+=le; tail[le]=q;
                    if(seqRecur(le-1)) return true;
                    restore(qs); out[j]--; sum[j]-=le;
                }
            }else{
                out[pu]++; sum[pu]+=le; tail[le]=p;
                if(seqRecur(le-1)) return true;
                out[pu]--; sum[pu]-=le;
            }
            out[pu]--; sum[pu]-=le; restore(ps);
        }
        return false;
    }

    static boolean seqRecur(int le){
        int n=l[le]; if(le<2) return true;
        int limit=n-1; if(out[le]==1) limit=n-tail[sum[le]];
        if(limit>u[le-1]) limit=u[le-1];
        int p=limit;
        for(int q=n-p; q<=p; q++,p--) if(tryPQ(p,q,le)) return true;
        return false;
    }

    static int seq(int n,int le,int[] buf){
        if(le==0) le = seqLen(n);
        stack=0; l[le]=n; u[le]=n;
        for(int i=0;i<=le;i++){ out[i]=0; sum[i]=0; }
        for(int i=2;i<le;i++){ l[i]=l[i-1]+1; u[i]=u[i-1]*2; }
        for(int i=le-1;i>2;i--){ if(l[i]*2<l[i+1]) l[i]=(1+l[i+1])/2; if(u[i]>=u[i+1]) u[i]=u[i+1]-1; }
        if(!seqRecur(le)) return 0;
        if(buf!=null) for(int i=0;i<=le;i++) buf[i]=u[i];
        return le;
    }

    static int seqLen(int n){
        if (FAST) {                  // fast fallback: binary upper bound only
            return binLen(n);
        }
        if(n<=known) return cache[n];
        while(known+1<n) seqLen(known+1);
        IntBox ub=new IntBox(); int lb=lower(n,ub);
        while(lb<ub.value && seq(n,lb,null)==0) lb++;
        known=n;
        if((n&1023)==0) System.out.printf("Cached %d%n", known);
        cache[n]=lb;
        return lb;
    }

    static int binLen(int n){
        int r=-1,o=-1;
        for(; n!=0; n>>=1, r++) if((n&1)!=0) o++;
        return r+o;
    }

    static final class Matrix {
        final double[][] a;
        Matrix(double[][] d){ a=d; }
        Matrix(int r,int c){ a=new double[r][c]; }

        Matrix mul(Matrix m2){
            int r=a.length, c=a[0].length, r2=m2.a.length, c2=m2.a[0].length;
            if(c!=r2) throw new IllegalArgumentException("Matrices cannot be multiplied.");
            Matrix res=new Matrix(r,c2);
            for(int i=0;i<r;i++) for(int j=0;j<c2;j++){
                double s=0; for(int k=0;k<r2;k++) s+=a[i][k]*m2.a[k][j];
                res.a[i][j]=s;
            }
            return res;
        }

        // exact chain powering (slow) – used only when FAST=false
        Matrix powByChain(int n, boolean printout){
            int[] e=new int[N]; Matrix[] v=new Matrix[N];
            int le=seq(n,0,e);
            if(printout){
                System.out.println("Addition chain:");
                for(int i=0;i<=le;i++){
                    char c=(i==le)?'\n':' ';
                    System.out.printf("%d%c", e[i], c);
                }
            }
            v[0]=this; v[1]=this.mul(this);
            for(int i=2;i<=le;i++){
                for(int j=i-1; j!=0; j--){
                    for(int k=j; k>=0; k--){
                        if(e[k]+e[j]<e[i]) break;
                        if(e[k]+e[j]>e[i]) continue;
                        v[i]=v[j].mul(v[k]);
                        j=1; break;
                    }
                }
            }
            return v[le];
        }

        // fast square-and-multiply
        Matrix powBinary(int exp, boolean printout){
            if(printout){
                System.out.println("Binary chain (exponents where we multiply):");
                boolean first=true;
                for(int i=31-Integer.numberOfLeadingZeros(exp); i>=0; i--){
                    if(((exp>>i)&1)==1){
                        if(!first) System.out.print(' ');
                        System.out.print(1<<i);
                        first=false;
                    }
                }
                System.out.println();
            }
            Matrix base=this;
            Matrix result = identity(a.length);
            int e=exp;
            while(e>0){
                if((e&1)==1) result = result.mul(base);
                e >>= 1;
                if(e!=0) base = base.mul(base);
            }
            return result;
        }

        Matrix pow(int n, boolean printout){
            return FAST ? powBinary(n, printout) : powByChain(n, printout);
        }

        static Matrix identity(int n){
            Matrix I=new Matrix(n,n);
            for(int i=0;i<n;i++) I.a[i][i]=1.0;
            return I;
        }

        void print(){
            for(double[] row: a){
                StringBuilder sb=new StringBuilder();
                for(int i=0;i<row.length;i++){
                    if(i>0) sb.append(' ');
                    sb.append(String.format("% f", row[i]));
                }
                System.out.println(sb);
            }
            System.out.println();
        }
    }

    public static void main(String[] args){
        int m=27182, n=31415;

        System.out.println("Precompute chain lengths:");
        // In FAST mode, seqLen uses binLen and returns immediately.
        seqLen(n);

        double rh=Math.sqrt(0.5);
        Matrix mx=new Matrix(new double[][]{
            { rh, 0,  rh, 0, 0, 0},
            { 0,  rh, 0,  rh, 0, 0},
            { 0,  rh, 0, -rh, 0, 0},
            {-rh, 0,  rh, 0, 0, 0},
            { 0,  0,  0,  0, 0, 1},
            { 0,  0,  0,  0, 1, 0},
        });

        System.out.println("\nThe first 100 terms of A003313 are:");
        for(int i=1;i<=100;i++){
            System.out.printf("%d ", seqLen(i));
            if(i%10==0) System.out.println();
        }

        int[] exs={m,n};
        Matrix[] mxs=new Matrix[2];
        for(int i=0;i<exs.length;i++){
            int ex=exs[i];
            System.out.printf("%nExponent: %d%n", ex);
            mxs[i]=mx.pow(ex, true);
            System.out.printf("A ^ %d:-%n%n", ex);
            mxs[i].print();
            System.out.println("Number of A/C multiplies: " + (FAST ? binLen(ex) : seqLen(ex)));
            System.out.println("  c.f. Binary multiplies: " + binLen(ex));
        }

        System.out.printf("%nExponent: %d x %d = %d%n", m, n, m*n);
        System.out.printf("A ^ %d = (A ^ %d) ^ %d:-%n%n", m*n, m, n);
        Matrix mx2 = (FAST ? mxs[0].powBinary(n, false) : mxs[0].powByChain(n, false));
        mx2.print();
    }
}

