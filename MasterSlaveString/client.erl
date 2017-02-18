-module(client).
-export([reverse/2, reverse/1]).

reverse(Stringa,NumPezzi) -> 'MasterProcess'!{reverse,Stringa,NumPezzi,self()}, receive
	Message -> io:format("~s ~n",[Message])
	end.
reverse(Stringa) -> 'MasterProcess'!{reverse,Stringa,self()}, receive
	Message -> io:format("~s ~n",[Message])
	end.