-module(client).
-export([is_prime/1, close/0]).

is_prime(N) -> {server,'amora@sandrag-UX303UB'}!{new,N,self()}, receive
	{result,V} -> io:format("~p ~n",[V])
end.

close() -> {server,'amora@sandrag-UX303UB'}!{quit,self()}, receive
	{quit, V} -> io:format("~p ~n",[V])
end.


