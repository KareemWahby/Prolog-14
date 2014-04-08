round(2,final).
round(4,semi_finals).
round(8,quarter_finals).
round(16,round_four).
round(32,round_five).
round(64,round_six).
round(128,round_seven).
round(256,round_eight).


schedule_round(2,R):-round(2,N),R = [game(1,2,N)].
schedule_round(N,R):-numlist(1,N,L),round(N,Rn),schedule_round1(L,Rn,R).

list_min([L|Ls], Min) :-
    list_min(Ls, L, Min).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
    Min1 is min(L, Min0),
    list_min(Ls, Min1, Min).

schedule_round1([],_,[]).
schedule_round1(L,Rn,R):-member(S1,L),list_min(L,S1),member(S2,L),S1<S2, S2+S1 =\= 3,delete(L,S1,L2),delete(L2,S2,L1),schedule_round1(L1,Rn,R1),R=[game(S1,S2,Rn)|R1].

schedule_rounds(2,[R]):-schedule_round(2,R).
schedule_rounds(X,R):- schedule_round(X,R1),X1 is X//2, schedule_rounds(X1,R2),append([R1],R2,R).