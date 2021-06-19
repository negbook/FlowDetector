
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
        FlowCheck("Pause",IsPauseMenuActive())
        Citizen.Wait(332)
    end
end)