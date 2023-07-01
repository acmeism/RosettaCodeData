/// <reference path="PrimeFactors.js" />

describe("Prime Factors", function() {
  it("Given nothing, empty is returned", function() {
    expect(factors()).toEqual([]);
  });

  it("Given 1, empty is returned", function() {
    expect(factors(1)).toEqual([]);
  });

  it("Given 2, 2 is returned", function() {
    expect(factors(2)).toEqual([2]);
  });

  it("Given 3, 3 is returned", function() {
    expect(factors(3)).toEqual([3]);
  });

  it("Given 4, 2 and 2 is returned", function() {
    expect(factors(4)).toEqual([2, 2]);
  });

  it("Given 5, 5 is returned", function() {
    expect(factors(5)).toEqual([5]);
  });

  it("Given 6, 2 and 3 is returned", function() {
    expect(factors(6)).toEqual([2, 3]);
  });

  it("Given 7, 7 is returned", function() {
    expect(factors(7)).toEqual([7]);
  });

  it("Given 8; 2, 2, and 2 is returned", function() {
    expect(factors(8)).toEqual([2, 2, 2]);
  });

  it("Given a large number, many primes factors are returned", function() {
    expect(factors(2*2*2*3*3*7*11*17))
      .toEqual([2, 2, 2, 3, 3, 7, 11, 17]);
  });

  it("Given a large prime number, that number is returned", function() {
    expect(factors(997)).toEqual([997]);
  });
});
