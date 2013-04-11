#include <iostream>
#include <vector>
// Hamming like sequences Generator
//
// Nigel Galloway. August 13th., 2012
//
class Ham {
private:
	std::vector<unsigned int> _H, _hp, _hv, _x;
public:
	bool operator!=(const Ham& other) const {return true;}
	Ham begin() const {return *this;}
        Ham end() const {return *this;}
	unsigned int operator*() const {return _x.back();}
	Ham(const std::vector<unsigned int> &pfs):_H(pfs),_hp(pfs.size(),0),_hv({pfs}),_x({1}){}
	const Ham& operator++() {
	  for (int i=0; i<_H.size(); i++) for (;_hv[i]<=_x.back();_hv[i]=_x[++_hp[i]]*_H[i]);
	  _x.push_back(_hv[0]);
	  for (int i=1; i<_H.size(); i++) if (_hv[i]<_x.back()) _x.back()=_hv[i];
	  return *this;
	}
};
