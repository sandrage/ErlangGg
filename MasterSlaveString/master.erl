-module(master).
-export([long_reverse_string/0]).

long_reverse_string() -> register('MasterProcess',spawn(fun()->reversing() end)).

long_reversed_string(_,K,Tokens,_,NumToken) when NumToken>=K -> lists:reverse(Tokens);
long_reversed_string(Stringa,K,Tokens,I,NumToken) when NumToken=<(length(Stringa) rem K) ->
					long_reversed_string(Stringa,K,[string:substr(Stringa,I,((length(Stringa) div K)+1))|Tokens], (I+(length(Stringa) div K)+1),NumToken+1);
long_reversed_string(Stringa,K,Tokens,I,NumToken) -> 
					long_reversed_string(Stringa,K,[string:substr(Stringa,I,(length(Stringa) div K))|Tokens], I+(length(Stringa) div K),NumToken+1).


reversing() -> receive
	{reverse,Stringa,NumDiPezzi, WhoAsked} -> 
				WhoAsked!receiveResult([spawn(slave,reverse_string,[Sub,self()]) || Sub<-long_reversed_string(Stringa,NumDiPezzi,[],1,0)],[]), 
				reversing();
	{reverse,Stringa,WhoAsked} -> WhoAsked!receiveResult([spawn(slave,reverse_string,[Sub,self()]) || Sub<-long_reversed_string(Stringa,10,[],1,0)],[]), 
				reversing()
end.

receiveResult([],Result) -> Result;
receiveResult([Pid|Pids],Result)-> receive
	{reversed,Pid,Stringa} -> receiveResult(Pids,(Stringa++Result))

end.