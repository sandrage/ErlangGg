-module(client).
-export([connecting/0]).


connecting() -> io:format("vengo al mondo "), receive
	{print,Term} -> io:format("~p~n",[Term]), connecting();
	end.