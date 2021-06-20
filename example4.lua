
CreateThread(function()
    FlowCheckCreate('Pause',false)
    RegisterFlowCallback("Pause",'change',function(name,old,new)
        print(name.."hi")
    end )
    RegisterFlowCallback("Pause",'same',function(name,old,new)
        print(name.."xD")
    end )
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)
