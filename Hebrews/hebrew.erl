-module(hebrew).
-export([hebrew/1]).

%% formato messaggi che gli ebrei possono ricevere {youHaveToDie,N,K,1,ListaPids}
searchNextThirdAlive(1,[{Pid,alive}|_],_) -> Pid;
searchNextThirdAlive(K,[],ListaCompleta) -> searchNextThirdAlive(K,ListaCompleta,ListaCompleta);
searchNextThirdAlive(K,[{_,dead}|Lista],ListaCompleta) -> searchNextThirdAlive(K,Lista,ListaCompleta);
searchNextThirdAlive(K,[{_,alive}|Lista],ListaCompleta) -> searchNextThirdAlive((K-1),Lista,ListaCompleta). 

hebrew(I) -> receive
	{youHaveToDie,1,_,_} -> exit({lastSurvivor,I});
	{youHaveToDie,N,K,ListaPids} -> NewListaPids=lists:keyreplace(self(), 1, ListaPids, {self(),dead}),
									  Pid=searchNextThirdAlive(K,lists:nthtail(I,NewListaPids),NewListaPids),
									  Pid!{youHaveToDie,(N-1),K,NewListaPids}
end.