(scl 17)
(load "@lib/math.l")

(setq
   *X-Table (range 0.0 1.55 0.05)
   *SinTable (mapcar sin *X-Table)
   *CosTable (mapcar cos *X-Table)
   *TanTable (mapcar tan *X-Table)
   *TrigRows (length *X-Table) )

(let N2 (>> 1 (* *TrigRows (dec *TrigRows)))
   (setq
      *InvSinTable (need N2)
      *InvCosTable (need N2)
      *InvTanTable (need N2) ) )

(de rho (Tbl Inv I N)
   (cond
      ((lt0 N) 0)
      ((=0 N) (get *X-Table I))
      (T
         (let Idx (+ I (>> 1 (* (- *TrigRows 1 N) (- *TrigRows N))))
            (or
               (get Inv Idx)
               (set (nth Inv Idx)  # only happens if value not computed yet
                  (+
                     (rho Tbl Inv (inc I) (- N 2))
                     (*/
                        (- (get Tbl I) (get Tbl (+ I N)))
                        1.0
                        (-
                           (rho Tbl Inv I (dec N))
                           (rho Tbl Inv (inc I) (dec N)) ) ) ) ) ) ) ) ) )

(de thiele (Tbl Inv X N)
   (if (> N *TrigRows)
      1.0
      (+
         (-
            (rho Tbl Inv 1 (dec N))
            (rho Tbl Inv 1 (- N 3)) )
         (*/
            (- X (get Tbl N))
            1.0
            (thiele Tbl Inv X (inc N)) ) ) ) )

(de iSin (X)
   (thiele *SinTable *InvSinTable X 1) )

(de iCos (X)
   (thiele *CosTable *InvCosTable X 1) )

(de iTan (X)
   (thiele *TanTable *InvTanTable 1.0 1) )
