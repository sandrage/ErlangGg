-module(client).
-export([reverse_request/2,close/0]).

reverse_request(String,PieceLength) -> {stringreverser,'sif@sandrag-UX303UB'}!{reverse,String,PieceLength,self()}, receive
	{reversed,Stringa} -> io:format("~p ~n",[Stringa])
end.
close() -> {stringreverser,'sif@sandrag-UX303UB'}!{close,self()}, receive
	{closed,String} -> io:format("~p ~n",[String])
end.