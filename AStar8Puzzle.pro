%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Searcher %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
search([Goal,_ ], Solution, Goal, Path) :- reverse([Goal|Path],Solution).
search(Expansions, Visited, Goal , Path) :- 
	applyOperators(Expansions, Visited, Goal,Expanded),
    search(Expanded, Visited, Goal, Path).

applyOperators([Ehead | Etail], Visited,Goal, NewExpansions) :- 
    right(Ehead, Etail,Goal,Visited,Eright),
    left(Ehead, Eright,Goal, Visited ,Eleft),
    up(Ehead, Eleft, Goal, Visited, Eup),
    down(Ehead, Eup,Goal, Visited, NewExpansions),
    \+equals(Etail, NewExpansions).

costFunction((X,Y):[]/ Cost, (Xpg,Ypg):[], Cacc ,NewCost) :- manDist(X, Y, Xpg, Ypg, C), NewCost is Cacc + C + Cost. 
costFunction(CH:[_-(X-Y) | T]/ Cost, GH:[_-(Xg,Yg) | Tg], Cacc ,NewCost) :- 
    manDist(X, Y, Xg, Yg, NCacc),
    costFunction(CH: T /Cost, GH : Tg, NCacc, NewCost). 

manDist(X,Y, XGOAL, YGOAL, RES) :- 
    DX is X - XGOAL,
	DY is Y - YGOAL,
    abs(DX, AbsX),
    abs(DY, AbsY),
    RES is DX + DY + Cacc.

costFunction(,[(X,Y)/C | T/])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERATORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
right((X,Y): Numbers/CurrCost,Expansions,Goal, Visited, OrderedExpansions) :- 
    X < 3, 
    NX is X + 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    costFunction((NX,Y):NewState, Goal, 0,Cost),
    \+member((NX,Y):NewState/Cost, Visited),
    insertOrdered((NX,Y):NewState/Cost, Expansions, OrderedExpansions).
    
right(_,Expansions,_,_,Expansions).

left((X,Y): Numbers/CurrCost ,Expansions, Goal, Visited, OrderedExpansions) :- 
    X > 1, 
    NX is X - 1, 
    goto(X, Y, NX, Y,Numbers, NewState),  
    costFunction((NX,Y):NewState, Goal, 0,Cost),
    \+member((NX,Y):NewState/Cost, Visited),
    insertOrdered((NX,Y):NewState/Cost, Expansions, OrderedExpansions).
left(_,Expansions,_,_,Expansions).

up((X,Y): Numbers/CurrCost, Expansions, Goal, Visited, OrderedExpansions) :- 
    Y < 3, 
    NY is Y + 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    costFunction((X,NY):NewState, Goal, 0,Cost),
    \+member((X,NY):NewState/Cost, Visited),
    insertOrdered((X,NY):NewState/Cost, Expansions, OrderedExpansions).
up(_,Expansions,_,_,Expansions).

down((X,Y):Numbers/CurrCost, Expansions, Goal, Visited, OrderedExpansions) :- 
    Y > 1, 
    NY is Y - 1, 
    goto(X, Y, X, NY,Numbers, NewState),  
    costFunction((X,NY):NewState, Goal, 0, Cost),
    \+member((X,NY):NewState/Cost, Visited),
    insertOrdered((X,NY):NewState/Cost, Expansions, OrderedExpansions).
down(_,Expansions,_,_,Expansions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

goto(FromX, FromY, ToX, ToY, [P-(ToX, ToY) | T] , [P-(FromX, FromY) | T]):- !.
goto(FromX, FromY, ToX, ToY,[H | T] , [H | NT]) :-  !, goto(FromX, FromY, ToX, ToY, T, NT).

equals(X,X).

insertOrdered(State, [], [State]):-!.
insertOrdered(State/Cost, [H/CostH | T], [State/Cost, H/CostH | T]) :- CostH >= Cost, !.
insertOrdered(State, [H | T], [H | R]) :-  insertOrdered(State, T, R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG AND TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeV([]) :- write('END'),nl,nl,nl,!.
writeV([H|T]) :- write('NEW STATE'),nl, write(H), nl, writeV(T).
%test(Path):- search().
