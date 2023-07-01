create temporary table inputs(remainder int, modulus int);

insert into inputs values (2, 3), (3, 5), (2, 7);

with recursive

-- Multiply out the product of moduli
multiplication(idx, product) as (
    select 1, 1

    union all

    select
        multiplication.idx+1,
        multiplication.product * inputs.modulus
    from
        multiplication,
        inputs
    where
        inputs.rowid = multiplication.idx
),

-- Take the final value from the product table
product(final_value) as (
    select max(product) from multiplication
),

-- Calculate the multiplicative inverse from each equation
multiplicative_inverse(id, a, b, x, y) as (
    select
        inputs.modulus,
        product.final_value / inputs.modulus,
        inputs.modulus,
        0,
        1
    from
        inputs,
        product

    union all

    select
        id,
        b, a%b,
        y - (a/b)*x, x
    from
        multiplicative_inverse
    where
        a>0
)
-- Combine residues into final answer
select
    sum(
        (y % inputs.modulus) * inputs.remainder * (product.final_value / inputs.modulus)
    ) % product.final_value
  from
    multiplicative_inverse, product, inputs
  where
    a=1 and multiplicative_inverse.id = inputs.modulus;
