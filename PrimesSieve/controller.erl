-module(controller).
-export([start/1]).

primes(N) -> [X || X<-lists:seq(2,N), length([Y || Y<-lists:seq(2,(X-1)), (X rem Y)==0])==0].

%%IO SONO IL SERVER 
%%createRing, il server è il primissimo a cui il primo deve parlare.
start(MaxValue) -> register(server,spawn(fun()->server(MaxValue) end)).

server(MaxValue) -> 
					Lista=[spawn_link(sieve,loop,[X]) || X<-primes(MaxValue)],
					createRing(Lista).

createRing([Pid|PidList]) -> createRing(Pid,[Pid|PidList],(PidList++[Pid])).

createRing(Pid,[Pid|PidList],[Pid1|PidList1]) -> Pid!{whoAreYou,self()},
		receive
			{iam,N} -> 
						Pid!{self(),Pid1,N}, createRing(Pid,PidList,PidList1)
		end;

createRing(Pid,[Pid1|[]],[Pid|[]]) -> Pid1!{whoAreYou,self()},
		receive
			{iam,N} -> 
					Pid1!{Pid,Pid,N}, startElaboration(Pid,N)
		end;
createRing(Pid,[Pid1|PidList],[Pid2|PidList2]) -> Pid1!{whoAreYou,self()},
	receive
		{iam,N} -> 
					Pid1!{Pid,Pid2,N}, createRing(Pid,PidList,PidList2)
	end.
startElaboration(Pid,Max) -> receive
	{new,N,From} -> io:format("You asked for: ~p ~n",[N]),
					if  
						(N>(Max*Max)) -> From!{result,lists:flatten(io_lib:format("Il numero ~p è troppo grande per essere valutato",[N]))}, startElaboration(Pid,Max);
						true -> Pid!{new,N}, receive
							{res,V} -> From!{result,lists:flatten(io_lib:format("Is ~p prime? ~p",[N,V]))}, startElaboration(Pid,Max)
						end
					end;
	{quit,From} -> From!{quit, "Il server è chiuso"}
end.