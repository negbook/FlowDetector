
CreateThread(function()
    FlowMakeLink({"A","B"},"Pause")
    FlowCheckCreate('Pause')
    FlowCheckCreate('A')
    FlowCheckCreate('B')
    FlowCheckCreate('C')
    FlowMakeLink("C","Pause")
    RegisterFlowCallback("Pause",'change',function(name,old,new,linkedname)
        linkedname = linkedname or 'self'
        print(name.."hi change ",tostring(old),tostring(new) .. 'from'..linkedname)
    end )
    RegisterFlowCallback("A",'change',function(name,old,new,linkedname)
        linkedname = linkedname or 'self'
        print(name.."A change ",tostring(old),tostring(new) .. 'from'..linkedname)
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
