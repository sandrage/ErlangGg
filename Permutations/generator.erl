-module(generator).
-export([generate/3]).

generate(M,Incr,Tot) -> Column=generate(M,Incr,Tot,[]), receive
	{giveMeColumn,Pid} -> Pid!{self(), column, Column}
end.

generate(0,_,Tot,PermutationColumn) -> lists:flatten(lists:duplicate(Tot,PermutationColumn));
generate(M,Incr,Tot,PermutationColumn) -> generate((M-1),Incr,Tot,((lists:duplicate(Incr,M))++PermutationColumn)).