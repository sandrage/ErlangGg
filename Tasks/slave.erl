-module(slave).
-export([compute/1]).

compute(Function) -> receive
	{next,MyNext} -> beginComputation(Function,MyNext)
end.

beginComputation(Function,MyNext) -> receive
	{exit} -> case MyNext of
					{_,lastOne} ->exit(normal), unregister(ring);
					_ ->MyNext!{exit}, exit(normal),unregister(ring)
				end;
	{compute,Input} -> case MyNext of
					{Pid,lastOne} ->Pid!{print,Function(Input)}, beginComputation(Function,MyNext);
					_ ->MyNext!{compute,Function(Input)}, beginComputation(Function,MyNext)
				end;
	{compute,Input,1,Next} -> case MyNext of
					{Pid,lastOne} -> Pid!{print,Function(Input)},beginComputation(Function,MyNext);
					_ -> MyNext!{compute,Function(Input),1,Next}, beginComputation(Function,MyNext)
				end;
	{compute,Input,Times,Next} -> case MyNext of
					{_,lastOne} -> Next!{compute,Function(Input),(Times-1),Next}, beginComputation(Function,MyNext);
					_ -> MyNext!{compute,Function(Input),Times,Next}, beginComputation(Function,MyNext)
				end
	end.