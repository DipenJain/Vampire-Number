defmodule VampireSupervisor do
    def start_link(n1,n2) do
        {:ok,pid} = VampireBoss.start_link()
        VampireBoss.printVampireNumbers(n1,n2,pid)
    end
end