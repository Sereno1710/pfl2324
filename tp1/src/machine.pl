/*validate_move([Board,Turn],[X1,Y1,Y2,X2]):-
    valid_source([Board, Turn], [X1,Y1], SourceNum),
    valid_destination([Board, Turn], [X2,Y2], DestNum), 
    get_max_steps(SourceNum, MaxSteps),
    valid_path(Board, [X1, Y1], [X2, Y2], MaxSteps),
    get_move_type(SourceNum, DestNum, MoveType).

valid_moves([Board,Turn], _ , ListOfMoves):-
    bagof([X1,Y1,X2,Y2],validate_move([Board,Turn],[X1,Y1,Y2,X2],SourceNum,DestNum,MoveType), ListOfMoves).


value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-
*/
