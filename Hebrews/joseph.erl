-module(joseph).
-export([joseph/2]).

joseph(N,K) -> process_flag(trap_exit,true),
					io:format("In a circle of ~p people, killing number ~p ~n",[N,K]),
				   startSuicide([{spawn_link(hebrew,hebrew,[I]),alive} || I<-lists:seq(1,N)],K).

startSuicide(ListaPids,K) -> {Pid,alive}=lists:nth(((K-1) rem (length(ListaPids)))+1,ListaPids),
							Pid!{youHaveToDie,length(ListaPids),K,ListaPids}, receive
	{'EXIT',_,{lastSurvivor,I}} -> io:format("Joseph is the Hebrew in position ~p ~n",[I])
end.

