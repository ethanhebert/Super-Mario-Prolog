/* 
Ethan Hebert and Karina Chang
2-24-23
CSC-330-002
Winter 2023
Project #2 - Super Mario Pro(log)
*/

:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(ballroom).

/* First Area - Peach's Castle */
path(ballroom, n, treasury).
path(treasury, s, ballroom).

path(ballroom, s, racetrack).
path(racetrack, n, ballroom).

path(ballroom, w, lavatory).
path(lavatory, e, ballroom).

path(ballroom, e, garden).
path(garden, w, ballroom).

path(garden, e, tower).
path(tower, w, garden).

path(tower, s, dungeon).
path(dungeon, e, jail).
path(jail, w, dungeon).

/* Second Area - Bowser's Castle */
path(tower, s, dungeon).
path(dungeon, e, jail).
path(jail, w, dungeon).

/* Items in Rooms */
at(table, ballroom).
at(carpet, ballroom).
at(cake, ballroom).
at(hors_doeuvres, ballroom).
at(blueshell, racetrack).
at(waluigi, racetrack).
at(honeycoupe, racetrack).
at(gold, treasury).
at(diamond, treasury).
at(netherite, treasury).
at(toad, treasury).
at(toilet, lavatory).
at(sink, lavatory).
at(medicine_cabinet, lavatory).
at(mushroom, lavatory).
at(daisy, garden).
at(flowers, garden).
at(fountain, garden).
at(pipe, tower).


/* These rules describe how to pick up an object. */

take(waluigi) :-
        write('Waluigi blushes and politely declines. With a soft
smile, he replies, ''Sorry... I''m already taken.'''),
        !, nl.

take(daisy) :-
        write('Daisy screams!!!
''UGH!!! DON''T TOUCH ME!!!
Anyways... have you seen Peach anywhere?'''),
        !, nl.

take(X) :-
        holding(X),
        write('You''re already holding it!'),
        !, nl.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(holding(X)),
        write('You took the '),
        write(X),
        write('.'),
        !, nl.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        holding(X),
        i_am_at(Place),
        retract(holding(X)),
        assert(at(X, Place)),
        write('You dropped the '),
        write(X),
        write('.'),
        !, nl.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).


/* This rule tells how to move in a given direction. */

/* Once you enter dungeon, you cannot exit. */
go(n) :-
        i_am_at(dungeon),
        write('Bowser uses his big dragon tail to block your exit!!!'),
        !, nl.

/* Can only enter dungeon if you have a mushroom to reach pipe. */
go(s) :-
        i_am_at(tower),
        holding(mushroom),
        write('Shimmying down the pipe...'), nl, nl,
        path(tower, s, dungeon),
        retract(i_am_at(tower)),
        assert(i_am_at(dungeon)),
        !, look.

go(s) :-
        i_am_at(tower),
        not(holding(mushroom)),
        write('I am not tall enough to enter this pipe...'),
        !, nl.

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        !, look.


go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.             -- to start the game.'), nl,
        write('n.  s.  e.  w.     -- to go in that direction.'), nl,
        write('take(Object).      -- to pick up an object.'), nl,
        write('drop(Object).      -- to put down an object.'), nl,
        write('look.              -- to look around you again.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(ballroom) :- write('You are in the ballroom of Peach\'s Castle!'), nl.
describe(treasury) :- write('You are in the treasury. mOnEy.'), nl.
describe(tower) :- write('You are in the tower.'), nl.
describe(garden) :- write('You are in the garden.'), nl.
describe(racetrack) :- write('You are currently in 12th place on the racetrack.'), nl.
describe(lavatory) :- write('You are in the lavatory. What\'s that smell???'), nl.
describe(dungeon) :- write('You are in Bowser''s Dungeon.'), nl, nl,
        write('Bowser guards a gate to the east.'), nl,
        write('MWAHAHA... WELL MARIO, IT SEEMS YOU HAVE FOUND MY SECRET
DUNGEON, POSSIBLY IN SEARCH OF YOUR LOST PEACH? WELL YOU''LL
HAVE TO GO THROUGH ME FIRST!!!'), nl.
describe(jail) :- write('You are in the jail. You found Peach!'), nl.