?- logtalk_load(heaps(loader)).  % also `{heaps(loader)}.` on most back-ends
% output varies by settings and what's already been loaded
?- heap(<)::new(H0),                           % H0 contains an empty heap
   heap(<)::insert(3, 'Clear drains', H0, H1), % as with Prolog, variables are in the mathematical
                                               % sense: immutable, so we make a new heap from the empty one
   heap(<)::insert(4, 'Feed cat',H1, H2),      % with each insertion a new heap
   heap(<)::top(H2, K2, V2),                   % K2=3, V2='Clear drains',
                                               % H2=t(2, [], t(3, 'Clear drains', t(4, 'Feed cat', t, t), t))
   heap(<)::insert_all(
      [
         5-'Make tea',
         1-'Solve RC tasks',
         2-'Tax return'
      ], H2, H3),                              % it's easier and more efficient to add items in K-V pairs
   heap(<)::top(H3, K3, V3),                   % K3=1, V3='Solve RC tasks',
                                               % H3=t(5, [], t(1, 'Solve RC tasks', t(3, 'Clear drains',
                                               % t(4, 'Feed cat', t, t), t), t(2, 'Tax return',
                                               % t(5, 'Make tea', t, t), t))),
   heap(<)::delete(H3, K3, V3, H4),            % K3=1, V3='Solve RC tasks',
                                               % H4=t(4, [5], t(2, 'Tax return', t(3, 'Clear drains',
                                               % t(4, 'Feed cat', t, t), t), t(5, 'Make tea', t, t))),
   heap(<)::top(H4, K4, V4).                   % K4=2, V4='Tax return'
