% clear_screen
clear_screen:- write('\33\[2J').

% display_game(+Board)
display_game(Board):-
  clear_screen, 
  nl, nl,
  display_lines(Board),
  nl, nl.

% display_lines(+Board)
display_lines([]):- !.
display_lines([NextLine | RemainingLines]):-
  display_line(NextLine),
  display_lines(RemainingLines).

% display_line(+Line)
display_line(Line):- 
  display_void(Line, -1),
  display_line_upper_border(Line), nl,
  display_void(Line, -1),
  display_line_content(Line), nl.

% display_line_upper_border(+Line)
display_line_upper_border([]):- !.
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

display_void([-1 | LineTail], -1):-
  write('  '),
  display_void(LineTail, -1).
display_void(_, _):- !.  