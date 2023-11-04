% board_size(+Board, -SizeX, -SizeY)
board_size(Board, [SizeX, SizeY]):-
  length(Board, SizeY),
  nth0(0, Board, Row),
  length(Row, SizeX).

get_tile_num(Board, [X, Y], TileNum):-
  nth0(Y, Board, Row),
  nth0(X, Row , TileNum).

find_tile_num(Board, TileNum):- 
  member(Row, Board),
  member(TileNum, Row).

get_units_tens(TileNum, Units, Tens):-
  Tens is TileNum // 10,
  Units is TileNum rem 10.

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
  I > -1, 
  NI is I-1, 
  replace(T, NI, X, R), !.
replace(L, _, _, L).
