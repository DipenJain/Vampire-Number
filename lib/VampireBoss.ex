defmodule VampireBoss do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__ ,[])
  end

  #---------------------- Server callbacks ----------------------#

  def init(args) do
    {:ok, args}
  end

  def handle_cast({:result,outputString},state) do
    {:noreply, [outputString | state]}
  end

  def handle_call(:result,_from,state) do
    {:reply,state,state}
  end

  def printVampireNumbers(n1,n2,pid) do

    start = n1
    last = n2
    batchSize = 50

    spawnChildServers(start,last,batchSize,pid)

  #--------Make a call back to the parent server to print the results--------#
    
    Enum.each(GenServer.call(pid,:result),fn x -> IO.puts x end)
  
  end

  def spawnChildServers(start,last,batchSize,pid) do

  #-----------Start worker child for every range with worker getting batch size amount of records-----------#
  
    list = Enum.chunk_every(start..last,batchSize)
    listOfTasks =
      Enum.map(list, fn x->
        l = length(x)
        [h|t] = x
          Task.async(fn ->
          VampireWorker.start_link(h,h+l-1,pid)
          end) end)

    #----------------Call the await function on the children to get back result from them----------------#
   
    Enum.map(listOfTasks, &Task.await/1)
  
  end
end