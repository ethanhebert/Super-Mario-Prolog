/* 
Ethan Hebert and Karina Chang
2-24-23
CSC-330-002
Winter 2023
Project #2 - Super Mario Pro(log)
*/

:- dynamic i_am_at/1, at/2, holding/1, dial/2.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(ballroom).

/* Paths between rooms */
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
at(daisy, garden).
at(flowers, garden).
at(fountain, garden).
at(pipe, tower).
at(bowser, dungeon).
at(lava, dungeon).
at(dry_bones, dungeon).
at(peach, jail).
at(pillow, jail).
at(snacks, jail).
at(nintendo_switch, jail).
at(legally_blonde_blu_ray, jail).

/* Current Dial Numbers for Gate */
dial(a,0).
dial(b,0).
dial(c,0).

/* These rules describe how to pick up an object. */

take(waluigi) :-
        i_am_at(Place),
        at(waluigi, Place),
        write('Waluigi blushes and politely declines. With a soft
smile, he replies, ''Sorry... I''m already taken.'''),
        !, nl.

take(daisy) :-
        i_am_at(Place),
        at(daisy, Place),
        write('Daisy screams!!!
''UGH!!! DON''T TOUCH ME!!!
Anyways... have you seen Peach anywhere?'''),
        !, nl.

take(peach) :-
        i_am_at(jail),
        at(peach, jail),
        write('You saved me, Mario!'),
        !, nl, win.

take(medicine_cabinet) :-
        i_am_at(Place),
        at(medicine_cabinet, Place),
        write('Man, this medicine cabinet is screwed in so tight. I can''t grab it!'),
        !, nl.

take(gate) :-
        i_am_at(Place),
        at(gate, Place),
        write('Bro. You cannot take a whole gate.'),
        !, nl.

take(lava) :-
        i_am_at(Place),
        at(lava, Place),
        write('You burned to a crisp.'),
        !, nl, die.

take(pipe) :-
        i_am_at(Place),
        at(pipe, Place),
        write('This pipe is glued to the floor!'),
        !, nl.

take(bowser) :-
        i_am_at(Place),
        at(bowser, Place),
        write('Don''t take me. Take on me. (a-ha)'),
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


/* These rules define how to punch! */
punch(medicine_cabinet) :-
        i_am_at(Place),
        at(medicine_cabinet, Place),
        retract(at(medicine_cabinet, Place)),
        assert(at(mushroom,lavatory)),
        write('You destroyed the medicine_cabinet.'), nl, nl,
        write('Hmm... there was something in there.'),
        !, nl.

/* punching Bowser reveals the gate and riddle */
punch(bowser) :-
        i_am_at(Place),
        at(bowser, Place),
        not(at(gate,dungeon)),
        write('THAT FELT LIKE A KITTEN PUNCH!!!'), nl, nl,
        write('Sorry. Anyways, I''m not here for a fist fight.
My son Ludwig has introduced me to the fine art of classical
music. I am more interested in your intellectual capacities than
your physical abilities. So, behind this gate is your lovely Peach.
To retrieve her, you must solve my riddle and input the answer into
the combination lock on the gate. Here it goes!'), nl, nl,
        write('What is the area code of my favroite US city (Ruston, LA)?'), nl, nl,
        write('PS... you have a new ''unlock.'' ability!'), 
        assert(at(gate,dungeon)),
        !, nl.

/* if you already punched Bowser, just show riddle. */
punch(bowser) :-
        i_am_at(Place),
        at(bowser, Place),
        at(gate,dungeon),
        write('You must''ve forgotten my riddle! Here it is.'), nl, nl,
        write('What is the area code of my favroite US city (Ruston, LA)?'),
        !, nl.

punch(peach) :-
        i_am_at(jail),
        at(peach, jail),
        write('Really???'),
        !, nl, die.

punch(mushroom) :-
        i_am_at(Place),
        at(mushroom, Place),
        write('You remain small eternally.'), !, nl,
        die.

punch(lava) :-
        i_am_at(Place),
        at(lava, Place),
        write('You burned to a crisp.'),
        !, nl, die.

punch(pipe) :-
        i_am_at(Place),
        at(pipe, Place),
        write('Ouchie! That''a hurt''a me fingie!'),
        !, nl.

punch(gate) :-
        i_am_at(Place),
        at(gate, Place),
        write('Ouchie! That''a hurt''a me fingie!'),
        !, nl.

punch(toilet) :-
        write('My hands stink. Gross.'),
        i_am_at(Place),
        at(toilet, Place),
        retract(at(toilet, Place)),
        !, nl.

punch(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        write('You destroyed the '),
        write(X),
        write('.'),
        !, nl.

punch(_) :-
        write('I don''t see it here.'),
        nl.

/* Unlock displays the gate dial and tests if it = 318 */

unlock :-
        i_am_at(dungeon),
        at(gate, dungeon),
        dial(a,3),
        dial(b,1),
        dial(c,8),
        write('
|-------------------------------------------------------|
  To increment or decrement a dial value, call inc(a).
  or dec(a). with the dial you wish to move (a, b, c).
|-------------------------------------------------------|'), write('
                  | [3] | [1] | [8] |'), write('
                  |  a  |  b  |  c  |'), write('
                |---------------------|'), write('
                    ACCESS  GRANTED    '), write('
                |---------------------|'), nl, nl,
        retract(i_am_at(dungeon)),
        assert(i_am_at(jail)),
        look, !, nl.

unlock :-
        i_am_at(dungeon),
        at(gate, dungeon),
        dial(a,A),
        dial(b,B),
        dial(c,C),
        write('
|-------------------------------------------------------|
  To increment or decrement a dial value, call inc(a).
  or dec(a). with the dial you wish to move (a, b, c).
|-------------------------------------------------------|'), write('
                  | ['),write(A),write('] | ['),write(B),write('] | ['),write(C),write('] |'), write('
                  |  a  |  b  |  c  |'), write('
                |---------------------|'), write('
                    ACCESS   DENIED    '), write('
                |---------------------|'), !, nl.

unlock :-
        write('What are you doing, silly???'), !, nl.


/* Increment and Decrement to move the gate dials */
inc(X) :-
        i_am_at(dungeon),
        at(gate, dungeon),
        retract(dial(X,N)),
        N1 is (N+1) mod 10,
        assert(dial(X,N1)),
        !, unlock.

inc(_) :-
        write('What are you doing, silly???'), !, nl.

dec(X) :-
        i_am_at(dungeon),
        at(gate, dungeon),
        retract(dial(X,N)),
        N1 is (N-1) mod 10,
        assert(dial(X,N1)),
        !, unlock.

dec(_) :-
        write('What are you doing, silly???'), !, nl.

/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

/* CHEAT CODEEEEE */
dung :-
        retract(i_am_at(_)),
        assert(i_am_at(dungeon)).


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
        write('
  _|_|_|    _|_|    _|      _|  _|_|_|_|
_|        _|    _|  _|_|  _|_|  _|      
_|  _|_|  _|_|_|_|  _|  _|  _|  _|_|_|  
_|    _|  _|    _|  _|      _|  _|      
  _|_|_|  _|    _|  _|      _|  _|_|_|_|  

  _|_|    _|      _|  _|_|_|_|  _|_|_|    
_|    _|  _|      _|  _|        _|    _|  
_|    _|  _|      _|  _|_|_|    _|_|_|    
_|    _|    _|  _|    _|        _|    _|  
  _|_|        _|      _|_|_|_|  _|    _|         
        '),
        halt.

/* Finding peach wins the game! */
win :-
        write('
  _|      _|    _|_|    _|    _|  
    _|  _|    _|    _|  _|    _|  
      _|      _|    _|  _|    _|  
      _|      _|    _|  _|    _|  
      _|        _|_|      _|_|   

_|          _|  _|_|_|  _|      _|
_|          _|    _|    _|_|    _|
_|    _|    _|    _|    _|  _|  _|
  _|  _|  _|      _|    _|    _|_|
    _|  _|      _|_|_|  _|      _|
        '),
        halt.

/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('|-------------------------------------------------------|'), nl,
        write('   Enter commands using standard Prolog syntax.'), nl,
        write('   Available commands are:'), nl,
        write('   start.             -- to start the game.'), nl,
        write('   n.  s.  e.  w.     -- to go in that direction.'), nl,
        write('   take(Object).      -- to pick up an object.'), nl,
        write('   drop(Object).      -- to put down an object.'), nl,
        write('   punch(Object).     -- to destroy an object.'), nl,
        write('   look.              -- to look around you again.'), nl,
        write('   instructions.      -- to see this message again.'), nl,
        write('   halt.              -- to end the game and quit.'), nl,
        write('|-------------------------------------------------------|'), nl.

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
describe(jail) :- write('You are in the jail. You found peach!'), nl.