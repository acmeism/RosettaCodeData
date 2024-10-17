using Base.Test
include("Palindrome_detection.jl")

# Simple test
@test palindrome("abcdcba")
@test !palindrome("abd")

# Test sets
@testset "palindromes" begin
    @test palindrome("aaaaa")
    @test palindrome("abcba")
    @test palindrome("1")
    @test palindrome("12321")
end

@testset "non-palindromes" begin
    @test !palindrome("abc")
    @test !palindrome("a11")
    @test !palindrome("012")
end
