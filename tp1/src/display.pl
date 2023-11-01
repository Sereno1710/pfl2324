% display_game(+GameState)
display_game(GameState):-
  display_lines(GameState).

% display_lines(+ListofLines)
display_lines([]):- !.
display_lines([NextLine | RemainingLines]):-
  display_line(NextLine),
  display_lines(RemainingLines).

% display_line(+Line)
display_line(Line):- 
  display_void(Line, -1),
  display_line_upper_border(Line), nl,
  display_void(Line, -1),
  display_line_content(Line), write('|'), nl.

% display_line_upper_border(+Line)
display_line_upper_border([]):- !.
display_line_upper_border([-1 | LineTail]):-
  display_line_upper_border(LineTail).
display_line_upper_border([_ | LineTail]):-
  write(' / \\'),
  display_line_upper_border(LineTail).

% display_line_content(+Line)
display_line_content([]):- !.
display_line_content([-1 | LineTail]):-
  display_line_content(LineTail).
display_line_content([LineHead | LineTail]):-
  get_tile_text(LineHead, TileText),
  write('|'), write(TileText),
  display_line_content(LineTail).

display_void([-1 | LineTail], -1):-
  write('  '),
  display_void(LineTail, -1).
display_void(_, _):- !.  

% get_tile_text(+TileNum, -TileText)
get_tile_text(TileNum, TileText):-
  Tens is TileNum // 10,
  Units is TileNum mod 10,
  get_tile_text(Tens, Units, TileText).
get_tile_text(_, ' ? ').

% get_tile_text(+Tens, +Units, -TileText)
get_tile_text(2, 0, ' G ').
get_tile_text(1, 0, '   ').
get_tile_text(_, Units, TileText):-
  Units >= 1, Units =< 8,
  get_piece(Units, _, _, TileText).
get_tile_text(_, _, ' ? ').
