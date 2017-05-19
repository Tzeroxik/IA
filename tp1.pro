search([Goal,_ ], Solution, Goal, Path) :- reverse([Goal|Path],Solution).
search(Expansions, Visited, Goal , Path) :- 
	applyOperators(Expansions, Visited, Expanded),
    %sort(CostExpanded, SortedExpanded),
    search(Expanded, Visited, Goal, Path).

applyOperators([Ehead | Etail], Visited, NewExpansions) :- 
    right(Ehead, Etail,Visited,Eright),
    left(Ehead, Eright, Visited ,Eleft),
    up(Ehead, Eleft, Visited, Eup),
    down(Ehead, Eup, Visited, NewExpansions),
    \+equals(Etail, NewExpansions).

costFunction(Expanded, Goal, CostExpanded)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERATORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
right((X,Y): Numbers/_,Expansions, Visited, [(NX,Y):NewState/_|Expansions]) :- 
    X < 3, 
    NX is X + 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    \+member((NX,Y):NewState, Visited).
right(_,Expansions,_,Expansions).

left((X,Y): Numbers / _,Expansions, Visited, [(NX,Y):NewState|Expansions]) :- 
    X > 1, 
    NX is X - 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    \+member((NX,Y):NewState, Visited).
left(_,Expansions,_,Expansions).

up((X,Y): Numbers, Expansions, Visited, [(X,NY):NewState|Expansions]) :- 
    Y < 3, 
    NY is Y + 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    \+member((X,NY):NewState, Visited).
up(_,Expansions,_,Expansions).

down((X,Y): Numbers, Expansions, Visited, [(X,NY):NewState | Expansions]) :- 
    Y > 1, 
    NY is Y - 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    \+member((X,NY):NewState, Visited).
down(_,Expansions,_,Expansions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goto(FromX, FromY, ToX, ToY, [P-(ToX, ToY) | T] , [P-(FromX, FromY) | T]):- !.
goto(FromX, FromY, ToX, ToY,[H | T] , [H | NT]) :-  !, goto(FromX, FromY, ToX, ToY, T, NT).

equals(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG AND TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeV([]) :- write('END'),nl,nl,nl,!.
writeV([H|T]) :- write('NEW STATE'),nl, write(H), nl, writeV(T).
%test(Path):- search().
