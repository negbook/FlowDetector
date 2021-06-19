local IsPause = false
FlowDetector.OnChange["Pause"] = function(name,old,new)
    if old == false then 
        print(name,"Turning On Pause")
    else 
        print(name,"Turning Off Pause")
    end 
end 

CreateThread(function()
    FlowCheckCreate("Pause")
    while true do
        IsPause = FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)

CreateThread(function()
    while true do
        print(IsPause)
        Citizen.Wait(1000)
    end
end)