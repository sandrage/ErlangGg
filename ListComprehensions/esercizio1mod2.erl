-module(esercizio1mod2).
-export([squared_int/1, intersect/2, symmetric_difference/2]).

squared_int(Lista)->lists:map((fun(A)->A*A end),[X || X<-(Lista), is_integer(X)]).

intersect(ListaA,ListaB) -> [X || X<-ListaA, not(length([Y || Y<-ListaB, X==Y])==0)].

symmetric_difference(ListaA,ListaB) -> [X || X<-ListaA, length([Y || Y<-ListaB, X==Y])==0] ++ [X || X<-ListaB, length([Y || Y<-ListaA, X==Y])==0].