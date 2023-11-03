# TP1 - PFL 23/24

## Group Information
- **Game**: Tactigon
- **Group**: 2

| Student number | Full name                  | Contribution |
| -------------- | -------------------------- | ------------ |
| 202108791      | Daniel José de Aguiar Gago | 50%          |
| 202108729      | José Miguel Sereno Santos  | 50%          |

## Installation and Execution
To run the game in both Linux and Windows environments, follow these steps:

1. Install [SICStus Prolog 4.8](https://sicstus.sics.se/download4.html).
2. Consult the `main.pl` file located in the `/src` directory by clicking on File -> Consult.
3. Choose the font `FreeMono` with font size `14` in Settings -> Font.
4. Use the starting predicate `play/0` to start the program.
```
| ?- play.
```

## Description of the Game

Tactigon is turn-based 2-player board game where each side (Red and Blue) has four types of pieces. They are the Circle, the Triangle, the Square, and the Pentagon. 

### Board Set Up

Each player starts with 6 Circles, 3 Triangles, 3 Squares and 1 Pentagon.

During initial setup, the pieces are placed according to the following diagram:

![Tactigon Board](resources/tactigon-board.png)

### Gameplay

#### Movement

- Usually, Red moves first, but it's up to the players to decide. 

- A turn consists of a player moving one of their pieces, and resolving any combat that may result from that movement.

- Pieces can move in any path and direction up to their maximum spaces (E.g a move does not need to be done in a straight line). The maximum spaces a piece can move is dictated by the following table:

| Piece    | Max spaces per turn |
| -------- | ------------------- |
| Circle   | 1 space             |
| Triangle | 3 spaces            |
| Square   | 4 spaces            |
| Pentagon | 5 spaces            |

- Pieces cannot jump over other pieces.



#### Combat

- Pieces enter combat when a player moves one of their pieces into a tile occupied by an enemy piece.

- Combat ends a player's turn (the piece cannot continue moving afterwards).

- Combat has two potential outcomes:
  1. The defending piece is captured.
  2. Both the atacking and defending pieces are captured.

- When a piece is captured, it is removed from the board and cannot return.

- Squares and Pentagons cannot attack certain pieces.

- The outcome of each combat is indicated by the following table:

![Combat Outcomes](resources/combat-outcomes.png)

### Objective

Achieving victory can be done in 2 ways.

1. Capturing the opposing Pentagon: if this piece is captured, the game instantly ends and the player that captured the Pentagon is the winner.

2. Gold Tile Victory: occupying both golden tiles at the **end** of your opponent's turn wins the game.
    
### Optional Advanced Rules

These are rules for players who are confortable with the basic ruleset and have enough knowledge of the game.

#### Advanced Rule 1

Squares can jump over other pieces, except for opposing pieces. A jumped tile still counts for the square's maximum spaces per turn. 

#### Advanced Rule 2

Pieces that start a turn on a golden tile may move one extra space:

| Piece    | Max spaces  when starting on a golden tile |
| -------- | ------------------------------------------ |
| Circle   | 2 spaces                                   |
| Triangle | 4 spaces                                   |
| Square   | 5 spaces                                   |
| Pentagon | 6 spaces                                   |

## Bibliography
Official Game Website - [https://tactigongame.com/how-to-play/](https://tactigongame.com/how-to-play/)

[https://www.redblobgames.com/grids/hexagons/](https://www.redblobgames.com/grids/hexagons/)