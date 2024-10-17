for i = 1 to length(a) do
    if (a[i] >= '0' and a[i] <= '9') then
	a[i] -= '0'
    end if
    if (b[i] >= '0' and b[i] <= '9') then
	b[i] -= '0'
    end if
    if (c[i] >= '0' and c[i] <= '9') then
	c[i] -= '0'
    end if
    printf(1, "%s%s%s\n", {a[i], b[i], c[i]})
end for
