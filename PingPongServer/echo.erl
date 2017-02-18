-module(echo).
-export([start/0,print/1,stop/0]).

start() -> register(pingpong, spawn(fun()->prepare() end)), ok.
print(Term) -> pingpong!{print,Term}, ok.
stop()-> pingpong!{stop}, ok.

prepare() -> spawn_link(client,connecting,[]), loop().

loop() -> receive
	{print,Term} -> io:format("~p~n",[Term]), loop();
	{stop} ->io:format("sto terminando hoho"), exit(kill)
	end.
