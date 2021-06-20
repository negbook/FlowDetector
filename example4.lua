CreateThread(function()
    FlowCheckCreateCallback("Pause",false,'change',function(name,old,new)
        print(name.."hi")
    end )
    FlowCheckCreateCallback("Pause",false,'same',function(name,old,new)
        print(name.."xD")
    end )
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)