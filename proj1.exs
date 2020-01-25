defmodule Proj1 do
    def start do
        start = String.to_integer(Enum.at(System.argv(),0))
        last = String.to_integer(Enum.at(System.argv(),1))
        if(start>=last) do
            VampireSupervisor.start_link(start,last)
        else
            VampireSupervisor.start_link(last,start)
        end
    end
end

Proj1.start