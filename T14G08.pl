%round(N,Rn) N is the number of players and Rn is the round name

round(2,final).
round(4,semi_finals).
round(8,quarter_finals).
round(16,round_four).
round(32,round_five).
round(64,round_six).
round(128,round_seven).
round(256,round_eight).

%schedule_round(N,R) generates a round R of all posible games with N players 

schedule_round(2,R):-
	round(2,N),
	R = [game(1,2,N)].

schedule_round(N,R):-
	numlist(1,N,L),
	round(N,Rn),
	schedule_round1(L,Rn,R).

%schedule_round_W(N,_,R) 

schedule_round_W(2,_,R):-
	round(2,N),
	R = [game(1,2,N)].

schedule_round_W(N,L,R):-
	round(N,Rn),
	schedule_round1(L,Rn,R).

%winners(L,W) gets a List winners W from the list of games L

winners([],[]).

winners([game(S,_,_)|T],[S|R]):-
	winners(T,R).

%list_min(L,Min) true if Min is the minimum of the List L

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).

list_min([], Min, Min).

list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).

%schedule_round1(L,Rn,R) generates a List of games R with round name Rn from the List of players L

schedule_round1([],_,[]).

schedule_round1(L,Rn,R):-
	member(S1,L),
	list_min(L,S1),
	member(S2,L),
	S1<S2,
	length(L,Len),
	HLen is Len//2,
	nth1(IS,L,S2),
	IS > HLen,
	delete(L,S1,L2),
	delete(L2,S2,L1),
	schedule_round1(L1,Rn,R1),
	R=[game(S1,S2,Rn)|R1].

%schedule_rounds(N,R) generates a list of rounds R with N players considering the winners

schedule_rounds(2,[R]):-
	schedule_round(2,R).

schedule_rounds(X,R):-
	schedule_round(X,R1),
	X1 is X//2,
	winners(R1,W),
    schedule_rounds_helper(X1,W,R2),
	append([R1],R2,R).

%schedule_rounds_helper(N,W,R) a helper method for schedule_rounds/2

schedule_rounds_helper(2,_,[R]):-
	schedule_round(2,R).

schedule_rounds_helper(N,W,R):-
	schedule_round_W(N,W,R1),
	N1 is N//2,
	winners(R1,W1),
	schedule_rounds_helper(N1,W1,R2),
	append([R1],R2,R).

divide([],[]).

divide(L3,[L|L1]):-
	L3 = [_,_|_],
	member(X,L3),
	delete(L3,X,J),
        member(Y,J),
	delete(J,Y,I),
	L=[X,Y],
	L=[game(A,_,_),
	   game(B,_,_)],
	A<B,
	L\=[game(1,_,_),game(2,_,_)],
	divide(I,L1).

divide(L3,[[Y]|L]):-
	L3 = [_|_],
        member(Y,L3),
	delete(L3,Y,I),
	divide(I,L).

divide(L3,[L|L4]):-
	L3 = [_,_,_|_],
	member(X,L3),delete(L3,X,J),
	member(Y,J),delete(J,Y,I),
	member(Z,I), delete(I,Z,K),
	L=[X,Y,Z],
	L=[game(A,_,_),
	   game(B,_,_),
	   game(C,_,_)],
	A<B,
	B<C,
	L\=[game(1,_,_),
	    game(2,_,_),_],
	divide(K,L4).

divide2([],K,K,D,_):-
	length(K,D).

divide2([H1|T],L1,K,D,N):-
	N-D=\=1,
    divide(H1,L),
    append(L1,L,Out),
	divide2(T,Out,K,D,N).

divide2([H1|T],L1,K,D,N):-
	N-D=:=1,
	divide1(H1,L),
	append(L,L1,Out),
	divide2(T,Out,K,D,N).

divide1([],[]).

divide1(L3,[[Y]|L]):-
	member(Y,L3),
	delete(L3,Y,I),
	divide1(I,L).

main_divide(N,L1,D):-
	schedule_rounds(N,L),
	divide2(L,[],L1,D,N).

check_game_list(H):-
	(length(H,1),true);
	(H=[game(X,_,R),game(Y,_,R)],(X<Y,(X\=1;Y\=2)));
    (H=[game(X,_,R),game(Y,_,R),game(Z,_,R)],(X<Y,Y<Z,(X\=1;Y\=2))).

tournament(N,D,List):-
	main_divide(N,List,D).














