defmodule VampireWorker do
    use GenServer
  
    def start_link(x,y,pid) do
       GenServer.start_link(__MODULE__,[x,y,pid],[])
    end
  
    def init(args) do
      n1 = Enum.at(args,0)
      n2 = Enum.at(args,1)
      pid = Enum.at(args,2)
      getVampireList(n1,n2,pid)
      {:ok,[]}
    end
  
    defp isFactor?(num,fac) when rem(num,fac) == 0 do
      true
    end
  
    defp isFactor?(num,fac) when rem(num,fac) != 0 do
        false
    end
  
    defp isFang(num,arrDig, fact1, fact2, digits) do
      if not(rem(fact1,10) == 0 and  rem(fact2,10) == 0) do
        concStr = to_string(fact1) <> to_string(fact2)
        arrFangs = digits.(concStr)
        if arrFangs == arrDig do
          true
        else
          false
        end
      else
        false
      end
    end
  
    defp hasEvenDigits(num) do
      digits = fn x -> x |> to_string() |> String.codepoints() |> Enum.sort() end
      noOfDigits = length(digits.(num))
      if rem(noOfDigits,2) == 0 do
        true
      else
        false
      end
    end
  
    defp printVampireNum(num,pid) do
        if hasEvenDigits(num) do
          digits = fn x -> x |> to_string() |> String.codepoints() |> Enum.sort() end
          arrDig = digits.(num)
          listFactors = Enum.filter(round(:math.pow(10,div(length(arrDig),2)-1))..round(:math.sqrt(num)), fn(factor) -> isFactor?(num,factor) and isFang(num,arrDig,factor,div(num,factor),digits) end)
          if listFactors != [] do
            pairs = for n <- listFactors, do: [n, round(num/n)]
            outputVampire = to_string(num) <> " " <> Enum.join(List.flatten(pairs), " ")

            #---- Call the boss with the output of the child ------#
            GenServer.cast(pid,{:result, outputVampire})
          end
        end
    end
    
    def getVampireList(n1,n2,pid) do
      Enum.each(n1..n2, fn(x) -> printVampireNum(x,pid) end)
    end
  end