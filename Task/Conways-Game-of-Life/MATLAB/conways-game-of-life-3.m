function GoL(S, N) %
    colormap copper; whitebg('black');
    G= round(rand(S));
    A = [S 1:S-1]; B = [2:S 1];
    for k=1:N
        Sum = G(A,:)+G(B,:)+G(:,B)+G(:,A)+G(A,B)+G(A,A)+G(B,B)+G(B,A);
        G = double((G & (Sum == 2)) | (Sum == 3));
        surf(G); view([0 90]); pause(0.001)
    end
end
