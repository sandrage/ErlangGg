-module(client).
-export([convert/5]).

convert(from,Source,to,Target,Temperature) -> system!{client,self(),from,Source,to,Target,Temperature}, receive
	{result,Temp} -> io:format("~p°~s are equivalent to ~p°~s ~n",[Temperature,Source,Temp,Target])
end.