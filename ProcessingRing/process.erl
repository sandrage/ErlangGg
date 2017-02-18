-module(process).
-export([process/0]).


process() -> receive
	{start,0,ManagerPid,FirstPid}->ManagerPid!{ringComplete,FirstPid}, processElab({imLast,FirstPid});
	{start,N,ManagerPid,FirstPid} -> Next=spawn_link(process,process,[]),Next!{start,N-1,ManagerPid,FirstPid}, processElab(Next)
end.

processElab(Next) -> receive
	{passMessage,0,_} -> io:format("0 ESIMO GIRO, SONO: ~p ~n",[self()]), exit(stopped);
	{passMessage,M,Message}-> io:format("Io ~p mando il messaggio: ~p per la ~pesima volta ~n",[self(),Message,M]),
					case Next of
						{imLast,FirstPid} ->FirstPid!{passMessage,M-1,Message}, processElab(Next);
						_ -> Next!{passMessage,M,Message}, processElab(Next)
					end
	end.	
