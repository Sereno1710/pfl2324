% clear_screen
clear_screen:- write('\33\[2J').

% display_game(+Board)
display_game(Board):-
  clear_screen, 
  nl, nl,
  display_y_coords(Board),
  display_lines(Board),
  nl, nl.

display_x_coords:- format('~5|', []).
display_x_coords(Count) :-
  Count >= 10,
  Count1 is Count // 10,
  Count2 is Count rem 10,
  format('~d~d - ', [Count1, Count2]).
display_x_coords(Count) :-
  Count < 10,
  format(' ~d - ', [Count]).


display_y_coords(Board):-
  board_size(Board, [SizeX, _]),
  display_y_coords_tens(SizeX), nl,
  display_y_coords_units(SizeX), nl,
  display_y_coords_arrows(SizeX), nl.

display_y_coords_tens(SizeX):-
  format('~26|', []),
  display_y_coords_tens(10, SizeX).
display_y_coords_tens(SizeX, SizeX).
display_y_coords_tens(Count, SizeX):-
  CountTens is Count // 10,
  format(' ~d', [CountTens]),
  Count1 is Count + 1,
  display_y_coords_tens(Count1, SizeX).

display_y_coords_units(SizeX):-
  format('~6|', []),
  display_y_coords_units(0, SizeX).
display_y_coords_units(SizeX, SizeX).
display_y_coords_units(Count, SizeX):-
  CountUnits is Count rem 10,
  format(' ~d', [CountUnits]),
  Count1 is Count + 1,
  display_y_coords_units(Count1, SizeX).

display_y_coords_arrows(SizeX):-
  format('~6|', []),
  display_y_coords_arrows(0, SizeX).
display_y_coords_arrows(SizeX, SizeX).
display_y_coords_arrows(Count, SizeX):-
  write(' |'),
  Count1 is Count + 1,
  display_y_coords_arrows(Count1, SizeX).

% display_lines(+Board)
display_lines(Board):- 
  board_size(Board, [_, SizeY]),
  MiddleY is SizeY // 2,
  display_lines(Board, 0, MiddleY).
display_lines([], _, _).
display_lines([NextLine | RemainingLines], Count, MiddleY):-
  display_line(NextLine, Count, MiddleY),
  Count1 is Count + 1,
  display_lines(RemainingLines, Count1, MiddleY).

% display_line(+Line, Count, MiddleY)
display_line(Line, Count, MiddleY):-
  Count < MiddleY, !,
  display_x_coords,
  display_void(Line),
  display_line_upper_border(Line), nl,
  display_x_coords(Count),
  display_void(Line),
  display_line_content(Line), nl.
display_line(Line, Count, MiddleY):-
  Count = MiddleY, !,
  display_x_coords,
  display_void(Line),
  display_line_upper_border(Line), nl,
  display_x_coords(Count),
  display_void(Line),
  display_line_content(Line), nl,
  display_x_coords,
  display_void(Line),
  display_line_lower_border(Line), nl.
display_line(Line, Count, MiddleY):-
  Count > MiddleY, !,
  display_x_coords(Count),
  display_void(Line),
  display_line_content(Line), nl,
  display_x_coords,
  display_void(Line),
  display_line_lower_border(Line), nl.

% display_line_upper_border(+Line)
display_line_upper_border([]).
display_line_upper_border([-1 | LineTail]):-
  display_line_upper_border(LineTail).
display_line_upper_border([_ | LineTail]):-
  write(' / \\'),
  display_line_upper_border(LineTail).

% display_line_content(+Line)
display_line_content([]):- write('|').
display_line_content([-1 | LineTail]):-
  display_line_content(LineTail).
display_line_content([LineHead | LineTail]):-
  get_tile_display(LineHead, TileText),
  format('| ~a ', [TileText]),
  display_line_content(LineTail).

% display_line_lower_border(+Line)
display_line_lower_border([]).
display_line_lower_border([-1 | LineTail]):-
  display_line_lower_border(LineTail).
display_line_lower_border([_ | LineTail]):-
  write(' \\ /'),
  display_line_lower_border(LineTail).

display_void(Line):- display_void(Line, -1).
display_void([-1 | LineTail], -1):-
  write('  '),
  display_void(LineTail, -1).
display_void(_, _):- !.  