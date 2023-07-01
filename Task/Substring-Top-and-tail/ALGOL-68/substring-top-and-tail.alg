#!/usr/local/bin/a68g --script #

STRING str="upraisers";
printf(($gl$,
  str,                      # remove no characters #
  str[LWB str+1:         ], # remove the first character #
  str[         :UPB str-1], # remove the last character #
  str[LWB str+1:UPB str-1], # remove both the first and last character #
  str[LWB str+2:         ], # remove the first 2 characters #
  str[         :UPB str-2], # remove the last 2 characters #
  str[LWB str+1:UPB str-2], # remove 1 before and 2 after #
  str[LWB str+2:UPB str-1], # remove 2 before and one after #
  str[LWB str+2:UPB str-2]  # remove both the first and last 2 characters #
))
