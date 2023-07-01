abundant=0; deficient=0; perfect=0; p=[];
for N=2:20000
    K=1:ceil(N/2);
    D=K(~(rem(N, K)));
    sD=sum(D);
    if sD<N
        deficient=deficient+1;
    elseif sD==N
        perfect=perfect+1;
    else
        abundant=abundant+1;
    end
end
disp(table([deficient;perfect;abundant],'RowNames',{'Deficient','Perfect','Abundant'},'VariableNames',{'Quantities'}))
