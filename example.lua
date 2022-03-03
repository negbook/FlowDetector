
CreateThread(function()
	while true do Wait(1000)
		Flow.CheckNative('haha',GetEntityCoords,PlayerPedId(),function(on)
			on.change = function(oldvalue,newvalue)
				print('change',oldvalue,newvalue)
			end
			on.same = function(oldvalue,newvalue)
				print('same',oldvalue,newvalue)
			end 
		end)
	end 
end)