bust:{[dict]
  grids:distinct raze(til 9)rotate\:/:dict where(ce dict)=9;
  wc:(count solve@)each grids;
  grids where wc=max wc }
