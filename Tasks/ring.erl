-module(ring).
-export([start/2,send_message/1,send_message/2, stop/0]).

start(ActorsNumber,FunctionList) -> register(ring,spawn(fun()->setRing(ActorsNumber,FunctionList) end)).

setRing(ActorsNumber,FunctionList) -> [Pid|PidsList]=[spawn_link(slave,compute,[lists:nth(N,FunctionList)]) || N<-lists:seq(1,ActorsNumber)],
			connect([Pid|PidsList],PidsList++[Pid]).

connect([Pid|[]],[First|[]])->Pid!{next,{self(),lastOne}}, loop(First);
connect([Pid|PidsList],[Next|PidsNext]) ->Pid!{next,Next}, connect(PidsList,PidsNext).

send_message(Input) -> ring!{start,Input}.
send_message(Input,Times) -> ring!{start,Input,Times}.

stop() -> ring!{stop}.

loop(First)-> receive
	{start,Input}->First!{compute,Input},loop(First);
	{start,Input,Times}->First!{compute,Input,Times,First},loop(First);
	{print,Output} -> io:format("~p ~n",[Output]),loop(First);
	{stop}->First!{exit},exit(stopped)
	end.	
