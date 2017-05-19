search([Goal,_ ], Solution, Goal, Path) :- reverse([Goal|Path],Solution).
search(Expansions, Visited, Goal , Path) :- 
	applyOperators(Expansions, Visited, Goal,Expanded),
    search(Expanded, Visited, Goal, Path).

applyOperators([Ehead | Etail], Visited,Goal, NewExpansions) :- 
    right(Ehead, Etail,Goal,Visited,Eright),
    left(Ehead, Eright,Goal, Visited ,Eleft),
    up(Ehead, Eleft,Goal, Visited, Eup),
    down(Ehead, Eup,Goal, Visited, NewExpansions),
    \+equals(Etail, NewExpansions).

%costFunction(Expanded, Goal, CostExpanded) - gives cost to new state.
%insertOrdered(CurrState, ExpansionsList, OrderedExpansionsList) - inserts element in ordered position.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERATORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
right((X,Y): Numbers/CurrCost,Expansions,Goal, Visited, OrderedExpansions) :- 
    X < 3, 
    NX is X + 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    \+member((NX,Y):NewState, Visited),
    costFunction((NX,Y):NewState, Goal, CurrCost, Cost),
    insertOrdered((NX,Y):NewState/Cost, Expansions, OrderedExpansions).
    
right(_,Expansions,_,_,Expansions).

left((X,Y): Numbers /CurrCost ,Expansions, Goal, Visited, OrderedExpansions) :- 
    X > 1, 
    NX is X - 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    \+member((NX,Y):NewState, Visited),
    costFunction((NX,Y):NewState, Goal, CurrCost, Cost),
    insertOrdered((NX,Y):NewState/Cost, Expansions, OrderedExpansions).
left(_,Expansions,_,_,Expansions).

up((X,Y): Numbers/CurrCost, Expansions, Goal, Visited, OrderedExpansions) :- 
    Y < 3, 
    NY is Y + 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    \+member((X,NY):NewState, Visited),
    costFunction((X,NY):NewState, Goal,CurrCost, Cost),
    insertOrdered((X,NY):NewState/Cost, Expansions, OrderedExpansions).
up(_,Expansions,_,_,Expansions).

down((X,Y):Numbers/CurrCost, Expansions, Goal, Visited, OrderedExpansions) :- 
    Y > 1, 
    NY is Y - 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    \+member((X,NY):NewState, Visited),
    costFunction((X,NY):NewState, Goal,CurrCost, Cost),
    insertOrdered((X,NY):NewState/Cost, Expansions, OrderedExpansions).
down(_,Expansions,_,_,Expansions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goto(FromX, FromY, ToX, ToY, [P-(ToX, ToY) | T] , [P-(FromX, FromY) | T]):- !.
goto(FromX, FromY, ToX, ToY,[H | T] , [H | NT]) :-  !, goto(FromX, FromY, ToX, ToY, T, NT).

equals(X,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG AND TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeV([]) :- write('END'),nl,nl,nl,!.
writeV([H|T]) :- write('NEW STATE'),nl, write(H), nl, writeV(T).
%test(Path):- search().
