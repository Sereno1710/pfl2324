% board_size(+Board, -SizeX, -SizeY)
% returns the length of the width and height of the board. 
board_size(Board, [SizeX, SizeY]):-
  length(Board, SizeY),
  nth0(0, Board, Row),
  length(Row, SizeX).

% get_tile_num(+Board, +Coordinates, -Tilenum)
% obtains the content of a tile.
get_tile_num(Board, [X, Y], TileNum):-
  nth0(Y, Board, Row),
  nth0(X, Row , TileNum).

% get_units_tens(+TileNum, ?Units, ?Tens)
% obtains the unit and the type of tile of a tile.
get_units_tens(TileNum, Units, Tens):-
  Tens is TileNum // 10,
  Units is TileNum rem 10.

% replace(+Board, +I, +NewDestNum, -NewBoard)
% after a move is done, it replaces the source tile and dest tile to the respective correct values.
% this function was provided by the user fortran on stack overflow
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- 
  I > -1, 
  NI is I-1, 
  replace(T, NI, X, R), !.
replace(L, _, _, L).