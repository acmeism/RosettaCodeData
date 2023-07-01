				for (auto x3 = 1; x3 < x2; x3++)
				{
					// go straight to the first appropriate x3, mod 30
					if (int err30 = (x0 + x1 + x2 + x3 - rs) % 30)
						x3 += 30 - err30;
					if (x3 >= x2)
						break;
					auto sum = s2 + pow5[x3];
