if system('rm input.txt') == 0
   disp('input.txt removed')
end
if system('rm /input.txt') == 0
   disp('/input.txt removed')
end
if system('rmdir docs') == 0
   disp('docs removed')
end
if system('rmdir /docs') == 0
   disp('/docs removed')
end
