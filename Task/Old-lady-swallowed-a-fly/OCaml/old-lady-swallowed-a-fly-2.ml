let dict = [|
  "_ha _c _e _p,\nQuite absurd_f_p;_`cat,\nFancy that_fcat;_j`dog,\nWhat a hog_\
  fdog;_l`pig,\nHer mouth_qso big_fpig;_d_r,\nShe just opened her throat_f_r;_i\
  cow,\n_mhow she_ga cow;_k_o,\nIt_qrather wonky_f_o;_a_o_bcow,_khorse...\nShe'\
  s dead, of course!\n";"_a_p_b_e ";"\nS_t ";" to catch the ";"fly,\nBut _mwhy \
  s_t fly,\nPerhaps she'll die!\n\n_ha";"_apig_bdog,_l`";"spider,\nThat wr_nj_n\
  tickled inside her;_aspider_b_c";", to_s a ";"_sed ";"There_qan old lady who_\
  g";"_a_r_bpig,_d";"_acat_b_p,_";"_acow_b_r,_i";"_adog_bcat,_j";"I don't know \
  ";"iggled and ";"donkey";"bird";" was ";"goat";" swallow";"he_gthe" |]

let rec old_lady part s =
  ExtString.String.fold_left (fun s c ->
    if s then old_lady dict.(Char.code c - 95) false
    else if c = '_' then true
    else (print_char c; s)
  ) s part

let _ =
  old_lady dict.(0) false
