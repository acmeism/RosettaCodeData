say '¬';
say "Too {¬Too}";
say "Moo {¬Moo}";
say "Foo {¬Foo}";

sub tbl (&op,$name) {
    say '';
    say "$name   Too Moo Foo";
    say "   ╔═══════════";
    say "Too║{op Too,Too} {op Too,Moo} {op Too,Foo}";
    say "Moo║{op Moo,Too} {op Moo,Moo} {op Moo,Foo}";
    say "Foo║{op Foo,Too} {op Foo,Moo} {op Foo,Foo}";
}

tbl(&infix:<∧>, '∧');
tbl(&infix:<∨>, '∨');
tbl(&infix:<→>, '→');
tbl(&infix:<≡>, '≡');

say '';
say 'Precedence tests should all print "Too":';
say ~(
    Foo ∧ Too ∨ Too ≡ Too,
    Foo ∧ (Too ∨ Too) ≡ Foo,
    Too ∨ Too ∧ Foo ≡ Too,
    (Too ∨ Too) ∧ Foo ≡ Foo,

    ¬Too ∧ Too ∨ Too ≡ Too,
    ¬Too ∧ (Too ∨ Too) ≡ ¬Too,
    Too ∨ Too ∧ ¬Too ≡ Too,
    (Too ∨ Too) ∧ ¬Too ≡ ¬Too,

    Foo ∧ Too ∨ Foo → Foo ≡ Too,
    Foo ∧ Too ∨ Too → Foo ≡ Foo,
);
