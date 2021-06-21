
CreateThread(function()
    FlowMakeLink({"A","B"},"Pause")
    FlowCheckCreate('Pause')
    FlowCheckCreate('A')
    FlowCheckCreate('B')
    FlowCheckCreate('C')
    FlowMakeLink("C","Pause")
    RegisterFlowCallback("Pause",'change',function(name,old,new,islinked,linkto)
        if islinked then 
        print(linkto.." change ",tostring(old),tostring(new) .. 'from '..name)
        end 
    end )
    RegisterFlowCallback("A",'change',function(name,old,new,islinked,linkto)
        if not islinked then 
        print(name.." change ",tostring(old),tostring(new) )
        end 
    end )
        FlowCheck("Pause",1)
        IsPause = FlowCheck("A",IsPauseMenuActive())
        FlowCheck("Pause",2)
    while true do
        IsPause = FlowCheck("A",IsPauseMenuActive())
        FlowCheck("B",not IsPauseMenuActive())
        FlowCheck("C",999+math.random())
        Citizen.Wait(332)
    end
end)
