-module(ring).
-export([start/3]).

start(M,N,Message) -> register(central,spawn(fun()->ringManager(M,N,Message) end)).


ringManager(M,N,Message)-> process_flag(trap_exit,true),
		Pid=spawn_link(process,process,[]), 
		Pid!{start,N,self(),Pid}, waitForStop(M,Message).

waitForStop(M,Message)-> 
	receive
		{ringComplete,Pid} -> Pid!{passMessage,M,Message}, waitForStop(M,Message);
		{'EXIT',_,_} -> finished
	end.