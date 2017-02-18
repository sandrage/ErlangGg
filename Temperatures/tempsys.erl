-module(tempsys).
-export([startsys/0]).

convertToAtom({A,B}) -> list_to_atom(lists:concat([A,B])).
%%from Celsius to...
toC(T) -> T.
toF(T) -> T*9/5+32.
toK(T) -> T+273.15.
toR(T) -> (T+273.15)*9/5.
toDe(T) -> (100-T)*3/2.
toN(T) -> T*33/100.
toRe(T) -> T*4/5.
toRo(T) -> T*21/40+7.5.

%%to Celsius from ...
fromC(T) -> T.
fromF(T) -> (T-32)*5/9.
fromK(T) -> T-273.15.
fromR(T) -> (T*5/9)-273.15.
fromDe(T) -> 100-(T*2/3).
fromN(T) -> T*100/133.
fromRe(T) -> T*5/4.
fromRo(T) -> (T-7.5)*40/21.

createProcessFrom({A,B})-> register(convertToAtom({from,B}), spawn(fun()->loopFrom(A) end)).
createProcessTo({A,B}) -> register(convertToAtom({to,B}), spawn(fun() ->loopTo(A) end)).

loopFrom(T) ->  receive
	{to,Target,Temperature,Pid} -> convertToAtom({to,Target})!{celsius,T(Temperature),Pid}, loopFrom(T)
end.
loopTo(T) -> receive
	{celsius,Temperature,Pid} -> Pid!{result,T(Temperature)}, loopTo(T) 
end.

startsys() -> ListaFrom=[{fun fromC/1,'C'},{fun fromF/1,'F'},{fun fromK/1,'K'},{fun fromR/1,'R'},{fun fromDe/1,'De'},{fun fromN/1,'N'},{fun fromRe/1,'Re'},{fun fromRo/1,'Ro'}],
			  ListaTo=[{fun toC/1,'C'},{fun toF/1,'F'},{fun toK/1,'K'},{fun toR/1,'R'},{fun toDe/1,'De'},{fun toN/1,'N'},{fun toRe/1,'Re'},{fun toRo/1,'Ro'}],
			  lists:map(fun createProcessFrom/1,ListaFrom),lists:map(fun createProcessTo/1,ListaTo),
			  register(system,spawn(fun()->beginConversion() end)).

beginConversion() -> receive
	{client,Pid,from,Source,to,Target,Temperature} -> convertToAtom({from,Source})!{to,Target,Temperature,Pid},beginConversion()
	end.

