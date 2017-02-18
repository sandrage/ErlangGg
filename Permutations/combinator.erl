-module(combinator).
-export([start/2]).

%i primi m elementi a gruppi di n
start(N,M) -> register(combinator,spawn(fun()->createSlaves(N,M) end)).

createSlaves(N,M) -> ListaPid=[spawn(generator,generate,[M,trunc(math:pow(M,E)),trunc(math:pow(M,(N-E-1)))]) || E<-lists:seq(0,(N-1))],
						join(ListaPid, []).

merging([],[]) -> [];
merging(Elems,[]) -> Elems;
merging([Elem|Elems],[Elem1|Elems1]) -> [lists:flatten([Elem,Elem1])|merging(Elems,Elems1)]. 

join([],Columns) -> io:format("~p ~n",[Columns]);
join([Pid|PidsList], Columns) -> Pid!{giveMeColumn,self()},
	receive
	{Pid, column, PartitionColumn} -> join(PidsList,merging(PartitionColumn,Columns))
	end. 
