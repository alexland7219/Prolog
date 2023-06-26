% A matrix which contains zeroes and ones gets "x-rayed" vertically and
% horizontally, giving the total number of ones in each row and column.
% The problem is to reconstruct the contents of the matrix from this
% information. Sample run:
%
%	?- p.
%	    0 0 7 1 6 3 4 5 2 7 0 0
%	 0                         
%	 0                         
%	 8      * * * * * * * *    
%	 2      *             *    
%	 6      *   * * * *   *    
%	 4      *   *     *   *    
%	 5      *   *   * *   *    
%	 3      *   *         *    
%	 7      *   * * * * * *    
%	 0                         
%	 0                         
%	

:- use_module(library(clpfd)).

ejemplo1( [0,0,8,2,6,4,5,3,7,0,0], [0,0,7,1,6,3,4,5,2,7,0,0] ).
ejemplo2( [10,4,8,5,6], [5,3,4,0,5,0,5,2,2,0,1,5,1] ).
ejemplo3( [11,5,4], [3,2,3,1,1,1,1,2,3,2,1] ).


p:-	ejemplo3(RowSums,ColSums),
	length(RowSums,NumRows),
	length(ColSums,NumCols),
	NVars is NumRows*NumCols,
	length(L,NVars),  % generate a list of Prolog vars (their names do not matter)
%1. Domain
	L ins 0..1,
	matrixByRows(L,NumCols,MatrixByRows),
	transpose(MatrixByRows, MatrixByCols),
%2. Constraints
	equalsSums(MatrixByRows, RowSums),
	equalsSums(MatrixByCols, ColSums),
%3. labeling
	label(L),
	pretty_print(RowSums,ColSums,MatrixByRows).


pretty_print(_,ColSums,_):- write('     '), member(S,ColSums), writef('%2r ',[S]), fail.
pretty_print(RowSums,_,M):- nl,nth1(N,M,Row), nth1(N,RowSums,S), nl, writef('%3r   ',[S]), member(B,Row), wbit(B), fail.
pretty_print(_,_,_):- nl.
wbit(1):- write('*  '),!.
wbit(0):- write('   '),!.
    
matrixByRows([], _, []).
matrixByRows(L, N, [R|RS]) :- 
	append(R, L1, L),
	length(R, N),
	matrixByRows(L1, N, RS).

equalsSums([], []) :- !.
equalsSums([R|RS], [S|SS]) :-
	exprSuma(R, Expr),
	Expr #= S,
	equalsSums(RS, SS).

exprSuma([], 0) :- !.
exprSuma([X|XS], X + Expr) :- exprSuma(XS, Expr).