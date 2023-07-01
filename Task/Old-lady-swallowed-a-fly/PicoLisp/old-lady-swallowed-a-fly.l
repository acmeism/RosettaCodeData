(de *Dict
   `(chop
      "_ha _c _e _p,/Quite absurd_f_p;_`cat,/Fancy that_fcat;_j`dog,\
         /What a hog_fdog;_l`pig,/Her mouth_qso big_fpig;_d_r,/She just \
         opened her throat_f_r;_icow,/_mhow she_ga cow;_k_o,/It_qrather \
         wonky_f_o;_a_o_bcow,_khorse.../She's dead, of course!/" )
   `(chop "_a_p_b_e ")
   `(chop "/S_t ")
   `(chop " to catch the ")
   `(chop "fly,/But _mwhy s_t fly,/Perhaps she'll die!//_ha")
   `(chop "_apig_bdog,_l`")
   `(chop "spider,/That wr_nj_ntickled inside her;_aspider_b_c")
   `(chop ", to_s a ")
   `(chop "_sed ")
   `(chop "There_qan old lady who_g")
   `(chop "_a_r_bpig,_d")
   `(chop "_acat_b_p,_")
   `(chop "_acow_b_r,_i")
   `(chop "_adog_bcat,_j")
   `(chop "I don't know ")
   `(chop "iggled and ")
   `(chop "donkey")
   `(chop "bird")
   `(chop " was ")
   `(chop "goat")
   `(chop " swallow")
   `(chop "he_gthe") )

(de oldLady (Lst Flg)
   (loop
      (let C (pop 'Lst)
         (cond
            (Flg
               (setq Flg
                  (oldLady (get *Dict (- (char C) 94))) ) )
            ((= "_" C) (on Flg))
            ((= "/" C) (prinl))
            (T (prin C)) ) )
      (NIL Lst) )
   Flg )

(oldLady (car *Dict))
