-module(merger).
-export([start/0]).

start() -> register(stringreverser,spawn(fun()->rev() end)).

createPids(String,PieceLength,N) -> [spawn(reverser,reversing,[string:substr(String,(I*PieceLength)+1,PieceLength)]) || I<-lists:seq(0,N-1)].

rev() -> receive
	{reverse,String,PieceLength,From} -> case length(String)>=PieceLength of 
										true ->	ActorsNumber=(length(String) div PieceLength)+1,
												io:format("I got ~p and  I'll ask ~p actors to reverse it! ~n", [String,ActorsNumber]),
												Pids=createPids(String,PieceLength,ActorsNumber), 
												From ! {reversed,join(Pids,"")}, rev();
										false -> From!{reversed, "Hai inserito una stringa e una lunghezza non ccettabili"}
									end;
	{close,From} -> io:format("I'm closing ... ~n"), From!{closed,"The service is closed!!!"}
	end.

join([],Acc) -> Acc;
join([Pid|Pids],Acc) -> receive
	{reversed,Pid,Reversed} -> io:format("~p ~n",[string:concat(Reversed,Acc)]),join(Pids,string:concat(Reversed,Acc))
end.