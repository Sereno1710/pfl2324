/*
-1 - Ignore

Units:
0 - Empty Tile
1 - Red Pentagon
2 - Red Square
3 - Red Triangle
4 - Red Circle
5 - Blue Pentagon
6 - Blue Square
7 - Blue Triangle
8 - Blue Circle

Tens:
1 - Normal Tile
2 - Gold Tile
*/
% inital_state(+Size, -GameState)
initial_state( _ , GameState) :-
    Board = [
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1],
        [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
        [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
        [14,-1,13,-1,11,-1,12,-1,14,-1,10,-1,18,-1,16,-1,15,-1,17,-1,18],
        [-1,10,-1,12,-1,13,-1,10,-1,10,-1,10,-1,10,-1,17,-1,16,-1,10,-1],
        [-1,-1,14,-1,10,-1,14,-1,10,-1,20,-1,10,-1,18,-1,10,-1,18,-1,-1],
        [-1,-1,-1,-1,-1,-1,-1,-1,-1,10,-1,10,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    ].

start_game(GameState , Player1, Player2, Turn):-  
  inital_state( _ , GameState),
  display_game(GameState),
  game_loop(Player1 , Player2 , Turn),
  game_over(GameState, Winner).


game_loop(Player1, Player2 , Turn):-
    
display_game(GameState):-

% get_piece(?Id, ?Piece, ?Colour, ?PieceText)
get_piece(1, pentagon, red, ' \x2B1F\ ').
get_piece(2, square, red, ' \x25A0\ ').
get_piece(3, triangle, red, ' \x25B2\ ').
get_piece(4, circle, red, ' \x25CF\ ').

get_piece(5, pentagon, blue, ' \x2B20\ ').
get_piece(6, square, blue, ' \x25A1\ ').
get_piece(7, triangle, blue, ' \x25B3\ ').
get_piece(8, circle, blue, ' \x25CB\ ').

get_element(X , Y , GameState , Piece):-
    nth0(X, GameState , Row ),
    nth0(Y, Row , Piece).

adjacent(X1, Y1, X2, Y2) :-
    (X2 is X1 + 1, Y2 is Y1 + 1; X2 is X1 + 1, Y2 is Y1 - 1).
adjacent(X1, Y1, X2, Y2) :-
    (X2 is X1 + 2 , Y2 is Y1; X2 is X1 - 2, Y2 is Y1).
adjacent(X1, Y1, X2, Y2) :-
    (X2 is X1 - 1, Y2 is Y1 + 1; X2 is X1 - 1, Y2 is Y1 - 1).

create_adjacency_list(Board, AdjList) :-
    findall((X1, Y1, X2, Y2), (
        between(0, 6, X1),
        between(0, 20, Y1),
        adjacent(X1, Y1, X2, Y2),
    ), AdjList).

bfs(AdjList, [X1, Y1], [X2, Y2], Path) :-
    bfs_queue([[X1-Y1]], [X2-Y2], Path, AdjList).

bfs_queue([[Node|Path]|_], [End|_], [Node|Path], _) :- Node = End.
bfs_queue([Path|Paths], End, FinalPath, Graph) :-
    Path = [Node|_],
    findall([Neighbor, Node|Path], (member(Neighbor, Graph, _), \+ member(Neighbor, Path)), NewPaths),
    append(Paths, NewPaths, Queue),
    bfs_queue(Queue, End, FinalPath, Graph).


create_adjacency_list(GameState, AdjList),


valid_moves(Gamestate,[X1 , Y1] , [X2 , Y2] ,Player , NewGameState):-
    X1 >= 0, Y1 >= 0, X2 >= 0 , Y2 >= 0, X1 <= 6, X2 <= 6 , Y1 <= 20 , Y2 <= 20,
    get_element(X1,Y1, GameState , Piece),
    Piece \= -1, Piece \= 10, Piece \= 20,
    get_piece(Piece, Value , Turn , _),
    Player =:= Turn,
    create_adjacency_list(Board , AdjList),
    bfs(AdjList, [X1,Y1], [X2,Y2], Path),
    write(Path).



move(+GameState, [X1,Y1], [X2,Y2], Player , -NewGameState):-
    valid_moves(Gamestate,[X1 , Y1] , [X2 , Y2] ,Player , NewGameState),
    

    valid_moves(GameState).

/*
valid_moves(+GameState, +Player, -ListOfMoves):-

game_over(+GameState, -Winner):-

value(+GameState, +Player, -Value):-

& Level 1 should return a valid random move. Level 2 should return the best one.
choose_move(+GameState, +Player, +Level, -Move):-




parse_input(Input, [X1, Y1], [X2, Y2]) :-
    atomic_list_concat([Start, End], '-', Input),
    atom_chars(Start, [X1Char, Y1Char]),
    atom_chars(End, [X2Char, Y2Char]),
    atom_number(X1Char, X1),
    atom_number(X2Char, X2),
    atom_chars(Y1Atom, [Y1Char]),
    atom_chars(Y2Atom, [Y2Char]),
    Y1 = Y1Atom,
    Y2 = Y2Atom.

*/



