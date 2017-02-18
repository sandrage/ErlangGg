-module(slave).
-export([reverse_string/2]).

reverse_string(Stringa,Pid) -> Pid!{reversed,self(),lists:reverse(Stringa)}.