-module(counting).
-export([dummy/0,dummyUno/0,dummyDue/0,tot/0,stop/0]).

occorrenzeMap() -> [{dummy,0},{dummyUno,0},{dummyDue,0},{tot,0}].

dummy() -> case whereis(server) of
			undefined -> register(server, spawn(fun()-> server(occorrenzeMap()) end)), server!{dummy}, ok;
			_ -> server!{dummy}, ok
			end.

dummyUno() -> case whereis(server) of
			undefined ->register(server, spawn(fun()-> server(occorrenzeMap()) end)), server!{dummyUno}, ok;
			_ -> server!{dummyUno}, ok
			end.
dummyDue() -> case whereis(server) of
			undefined -> register(server, spawn(fun()-> server(occorrenzeMap()) end)), server!{dummyDue}, ok;
			_ -> server!{dummyDue}, ok
			end.



tot() -> case whereis(server) of
			undefined -> register(server, spawn(fun()-> server(occorrenzeMap()) end)),server!{tot,(self())}, ok;
			_ -> server!{tot,(self())}, ok
			end,
		receive
			Occorrenze->Occorrenze
		end.
stop() -> server!{stop}.

server(Occorrenze) ->receive
			{dummy} -> {_,{_,V}}=lists:keysearch(dummy, 1, Occorrenze),
						server(lists:keyreplace(dummy, 1, Occorrenze, {dummy,(V+1)}));
			{dummyUno} -> {_,{_,V}}=lists:keysearch(dummyUno, 1, Occorrenze),
							server(lists:keyreplace(dummyUno, 1, Occorrenze, {dummyUno,(V+1)}));
			{dummyDue} -> {_,{_,V}}=lists:keysearch(dummyDue, 1, Occorrenze),
							server(lists:keyreplace(dummyDue, 1, Occorrenze, {dummyDue,(V+1)}));
			{tot,Pid} -> {_,{_,V}}=lists:keysearch(tot, 1, Occorrenze),
						NewOcc=lists:keyreplace(tot, 1, Occorrenze, {tot,(V+1)}), Pid!NewOcc, server(NewOcc);
			{stop} -> server_stopped
		end.



