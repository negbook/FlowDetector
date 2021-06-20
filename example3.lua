CreateThread(function()
    FlowCheckCreate("Pause",false,function(name,old,new)
        print(name.." change")
    end )
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)