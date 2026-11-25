% Tic-Tac-Toe in SWI-Prolog
% A simple two-player terminal game.

:- use_module(library(readutil)).

start :-
    empty_board(Board),
    play(Board, x).

empty_board([1,2,3,4,5,6,7,8,9]).

play(Board, Player) :-
    display_board(Board),
    format('Player ~w, choose a square (1-9): ', [Player]),
    read_line_to_string(user_input, Input),
    (   catch(number_string(Position, Input), _, fail),
        integer(Position),
        Position >= 1,
        Position =< 9,
        nth1(Position, Board, Cell),
        integer(Cell)
    ->  replace_at(Board, Position, Player, NewBoard),
        continue_game(NewBoard, Player)
    ;   writeln('Invalid move. Choose an empty square from 1 to 9.'),
        play(Board, Player)
    ).

continue_game(Board, Player) :-
    (   winner(Board, Player)
    ->  display_board(Board),
        format('Player ~w wins!~n', [Player])
    ;   board_full(Board)
    ->  display_board(Board),
        writeln('It is a draw!')
    ;   next_player(Player, Next),
        play(Board, Next)
    ).

display_board([A,B,C,D,E,F,G,H,I]) :-
    nl,
    format(' ~w | ~w | ~w ~n', [A,B,C]),
    writeln('---+---+---'),
    format(' ~w | ~w | ~w ~n', [D,E,F]),
    writeln('---+---+---'),
    format(' ~w | ~w | ~w ~n~n', [G,H,I]).

replace_at([_|Tail], 1, Value, [Value|Tail]).
replace_at([Head|Tail], Position, Value, [Head|NewTail]) :-
    Position > 1,
    Next is Position - 1,
    replace_at(Tail, Next, Value, NewTail).

next_player(x, o).
next_player(o, x).

board_full(Board) :-
    \+ (member(Cell, Board), integer(Cell)).

winner(Board, Player) :-
    winning_line(A, B, C),
    nth1(A, Board, Player),
    nth1(B, Board, Player),
    nth1(C, Board, Player).

winning_line(1,2,3).
winning_line(4,5,6).
winning_line(7,8,9).
winning_line(1,4,7).
winning_line(2,5,8).
winning_line(3,6,9).
winning_line(1,5,9).
winning_line(3,5,7).
