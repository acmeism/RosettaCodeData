-module(rbtree).
-export([insert/3, find/2]).

% Node structure: { Key, Value, Color, Smaller, Bigger }

find(_, nil) ->
  not_found;
find(Key, { Key, Value, _, _, _ }) ->
  { found, { Key, Value } };
find(Key, { Key1, _, _, Left, _ }) when Key < Key1 ->
  find(Key, Left);
find(Key, { Key1, _, _, _, Right }) when Key > Key1 ->
  find(Key, Right).

insert(Key, Value, Tree) ->
  make_black(ins(Key, Value, Tree)).

ins(Key, Value, nil) ->
  { Key, Value, r, nil, nil };
ins(Key, Value, { Key, _, Color, Left, Right }) ->
  { Key, Value, Color, Left, Right };
ins(Key, Value, { Ky, Vy, Cy, Ly, Ry }) when Key < Ky ->
  balance({ Ky, Vy, Cy, ins(Key, Value, Ly), Ry });
ins(Key, Value, { Ky, Vy, Cy, Ly, Ry }) when Key > Ky ->
  balance({ Ky, Vy, Cy, Ly, ins(Key, Value, Ry) }).

make_black({ Key, Value, _, Left, Right }) ->
  { Key, Value, b, Left, Right }.

balance({ Kx, Vx, b, Lx, { Ky, Vy, r, Ly, { Kz, Vz, r, Lz, Rz } } }) ->
  { Ky, Vy, r, { Kx, Vx, b, Lx, Ly }, { Kz, Vz, b, Lz, Rz } };
balance({ Kx, Vx, b, Lx, { Ky, Vy, r, { Kz, Vz, r, Lz, Rz }, Ry } }) ->
  { Kz, Vz, r, { Kx, Vx, b, Lx, Lz }, { Ky, Vy, b, Rz, Ry } };
balance({ Kx, Vx, b, { Ky, Vy, r, { Kz, Vz, r, Lz, Rz }, Ry }, Rx }) ->
  { Ky, Vy, r, { Kz, Vz, b, Lz, Rz }, { Kx, Vx, b, Ry, Rx } };
balance({ Kx, Vx, b, { Ky, Vy, r, Ly, { Kz, Vz, r, Lz, Rz } }, Rx }) ->
  { Kz, Vz, r, { Ky, Vy, b, Ly, Lz }, { Kx, Vx, b, Rz, Rx } };
balance(T) ->
  T.
