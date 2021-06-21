
CreateThread(function()
    FlowDetector.Link({"A","B"},"Pause")
    FlowDetector.Create('Pause')
    FlowDetector.Create('A')
    FlowDetector.Create('B')
    FlowDetector.Create('C')
    FlowDetector.Link("C","Pause")
    FlowDetector.Register("Pause",'change',function(name,old,new,islinked,linkto)
        if islinked then 
        print(linkto.." change ",tostring(old),tostring(new) .. 'from '..name)
        end 
    end )
    FlowDetector.Register("A",'change',function(name,old,new,islinked,linkto)
        if not islinked then 
        print(name.." change ",tostring(old),tostring(new) )
        end 
    end )
        FlowDetector.Check("Pause",1)
        IsPause = FlowDetector.Check("A",IsPauseMenuActive())
        FlowDetector.Check("Pause",2)
    while true do
        IsPause = FlowDetector.Check("A",IsPauseMenuActive())
        FlowDetector.Check("B",not IsPauseMenuActive())
        FlowDetector.Check("C",999+math.random())
        Citizen.Wait(332)
    end
end)
