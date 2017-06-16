%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Searcher %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
search(InitialState, Goal, Solution) :- 
    canSolve(InitialState, Goal),
    !,
    solve(InitialState, Goal, Solution).

solve([(PosH, Pieces, Cost, _, Moves) |_],(PosH, Pieces), Solution/Cost) :- reverse(Moves,Solution).
solve([],_,_) :- !, fail.
solve(AvailableStates, Goal ,Path) :- 
	applyOperators(AvailableStates, Goal, NAvailableStates),
    solve(NAvailableStates, Goal, Path).

canSolve(_,_).

applyOperators([EHead | STail], Goal, NewAvailableStates) :- 
    right(EHead, STail,Goal ,SRight),
    left(EHead, SRight,Goal ,SLeft),
    up(EHead, SLeft, Goal, SUp),
    down(EHead, SUp, Goal, NewAvailableStates).

costFunction(X-Y,[], (Xpg-Ypg,[]), Cost, Cacc , NewCost) :-
    manDist(X, Y, Xpg, Ypg, C), NewCost is Cacc + C + Cost. 
costFunction(CH,[X-Y | T], (GH,[Xg-Yg | Tg]),Cost, Cacc ,NewCost) :-
    manDist(X, Y, Xg, Yg, Res),
    NCacc is Res + Cacc,
    costFunction(CH, T , (GH, Tg), Cost, NCacc, NewCost).

manDist(X,Y, XGOAL, YGOAL, RES) :- 
    DX is X - XGOAL,
	DY is Y - YGOAL,
    abs(DX, AbsX),
    abs(DY, AbsY),
    RES is AbsX + AbsY.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OPERATORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
right((CurrX-CurrY, Pieces, Cost, Visited,Moves),Expansions ,Goal , OrderedExpansions) :- 
    CurrX < 3,
    NX is CurrX + 1, 
    goto(CurrX, CurrY, NX, CurrY, Pieces, NPieces),  
    costFunction(NX-CurrY, NPieces, Goal, Cost, 0, NCost),
    \+member((NX-CurrY,NPieces), Visited),
    insertOrdered((NX-CurrY,NPieces,NCost,[(CurrX-CurrY,Pieces)|Visited],[right|Moves]), Expansions, OrderedExpansions).
right(_,Expansions,_,Expansions).

left((CurrX-CurrY, Pieces, Cost, Visited,Moves),Expansions ,Goal , OrderedExpansions) :- 
    CurrX > 1, 
    NX is CurrX - 1, 
    goto(CurrX, CurrY, NX, CurrY, Pieces, NPieces),  
    costFunction(NX-CurrY, NPieces, Goal, Cost, 0, NCost),
    \+member((NX-CurrY,NPieces), Visited),
    insertOrdered((NX-CurrY,NPieces,NCost,[(CurrX-CurrY,Pieces)|Visited],[left|Moves]), Expansions, OrderedExpansions).
left(_,Expansions,_,Expansions).

down((CurrX-CurrY, Pieces, Cost, Visited, Moves),Expansions ,Goal , OrderedExpansions) :- 
    CurrY < 3, 
    NY is CurrY + 1, 
    goto(CurrX, CurrY, CurrX, NY, Pieces, NPieces),  
    costFunction(CurrX-NY, NPieces, Goal, Cost, 0, NCost),
    \+member((CurrX-NY, NPieces), Visited),
    insertOrdered((CurrX-NY,NPieces,NCost,[(CurrX-CurrY,Pieces)|Visited],[down|Moves]), Expansions, OrderedExpansions).
down(_,Expansions,_,Expansions).

up((CurrX-CurrY, Pieces, Cost, Visited,Moves), Expansions, Goal, OrderedExpansions) :- 
    CurrY > 1, 
    NY is CurrY - 1, 
    goto(CurrX, CurrY, CurrX, NY, Pieces, NPieces),  
    costFunction(CurrX-NY, NPieces, Goal, Cost, 0, NCost),
    \+member((CurrX-NY, NPieces), Visited),
    insertOrdered((CurrX-NY,NPieces,NCost,[(CurrX-CurrY,Pieces)|Visited],[up|Moves]), Expansions, OrderedExpansions).
up(_,Expansions,_,Expansions).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% UTILS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


goto(FromX, FromY, ToX, ToY, [(ToX - ToY) | T] , [(FromX - FromY) | T]):- !.
goto(FromX, FromY, ToX, ToY,[H | T] , [H | NT]) :-  !, goto(FromX, FromY, ToX, ToY, T, NT).


insertOrdered(State, [], [State]):-!.
insertOrdered((State,Pieces,Cost,Visited), [(CState,CPieces,CCost,CVisited) | T], [(State,Pieces,Cost,Visited),(CState,CPieces,CCost,CVisited) | T]) :- CCost >= Cost, !.
insertOrdered(State, [H | T], [H | R]) :-  insertOrdered(State, T, R).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUG AND TEST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeV([]) :- write('END'),nl,!.
writeV([H|T]) :- write('NEW STATE'),nl, write(H), nl, writeV(T).
test:- search([(1-1,[2-1,3-1,1-2,2-2,3-2,1-3,2-3,3-3],0,[],[])],(3-3,[1-1,3-1,1-2,2-1,3-2,1-3,2-2,2-3]), Path),
write("new search:"),nl,write(Path),nl,write("end"),nl.
%writeV(Path),write(Cost).
%structure of State: (X-Y, [X-Y |TPieces], Cost, [HVisited, TVisited])
%{0,1,2},{3,4,5},{6,7,8}
%{1,4,2},{3,7,5},{6,8,0}

