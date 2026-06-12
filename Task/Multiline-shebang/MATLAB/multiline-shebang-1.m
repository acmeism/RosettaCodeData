#!/bin/sh
matlab -nojvm -nodisplay -nosplash -r "varargin = regexp('${1+"$@"}', ' ', 'split'); nvarargin = length(varargin); run('$1'); exit" | tail -n +16
