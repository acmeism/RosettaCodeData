function dft(A::AbstractArray{T,N}) where {T,N}
    F = zeros(complex(float(T)), size(A)...)
    for k in CartesianIndices(F), n in CartesianIndices(A)
        F[k] += cispi(-2 * sum(d -> (k[d] - 1) * (n[d] - 1) /
            real(eltype(F))(size(A, d)), ntuple(identity, Val{N}()))) * A[n]
    end
    return F
end

function idft(A::AbstractArray{T,N}) where {T,N}
    F = zeros(complex(float(T)), size(A)...)
    for k in CartesianIndices(F), n in CartesianIndices(A)
        F[k] += cispi(2 * sum(d -> (k[d] - 1) * (n[d] - 1) /
            real(eltype(F))(size(A, d)), ntuple(identity, Val{N}()))) * A[n]
    end
    return F ./ length(A)
end

seq = [2, 3, 5, 7, 11]
fseq = dft(seq)
newseq = idft(fseq)
println("$seq =>\n$fseq =>\n$newseq =>\n", Int.(round.(newseq)))

seq2 = [2 7; 3 11; 5 13]
fseq = dft(seq2)
newseq = idft(fseq)
println("$seq2 =>\n$fseq =>\n$newseq =>\n", Int.(round.(newseq)))
