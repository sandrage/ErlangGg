-module(sieve).
-export([loop/1]).

loop(N) -> receive
	{whoAreYou,Pid} -> Pid!{iam,N},loop(N);
	{Primo,Successivo,N} -> loop(Primo,Successivo,N)
	end.	

loop(Primo,Successivo,MyNumber) -> receive
	{pass,N} -> if
		((MyNumber*MyNumber)>N) -> Primo!{res,true}, loop(Primo,Successivo,MyNumber);
		((N rem MyNumber)==0) -> Primo!{res,false}, loop(Primo,Successivo,MyNumber);
		true -> Successivo!{pass,N}, loop(Primo,Successivo,MyNumber)
	end;
	{new,N} -> if 
				((MyNumber*MyNumber)>N) -> Primo!{res,true}, loop(Primo,Successivo,MyNumber);
				((N rem MyNumber) ==0) -> Primo!{res,false}, loop(Primo,Successivo,MyNumber);
				true -> Successivo!{pass,N}, loop(Primo,Successivo,MyNumber)
			end;
	{res,R} -> Primo!{res,R}, loop(Primo,Successivo,MyNumber)
end.
