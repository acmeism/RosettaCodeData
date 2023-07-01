mapping m2 = ([ "car": ([ "ford":17, "volvo":42 ]) ]);
write("#ford: %O, #volvo: %O\n",
      m2->car->ford,
      m2["car"]["volvo"]);
