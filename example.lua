

CreateThread(function()
	local function j ()
		return math.random(1,10)
	end 
	while true do Wait(1000)
		Flow.CheckNative('haha',GetEntityCoords,PlayerPedId(),function(on)
			on.change = function(oldvalue,newvalue)
				print('change',oldvalue,newvalue)
			end
			on.same = function(oldvalue,newvalue)
				print('same',oldvalue,newvalue)
			end 
		end)
		
		Flow.CheckValue('haha2',j(),function(on)
			on.change = function(oldvalue,newvalue)
				print('change',oldvalue,newvalue)
			end
			on.same = function(oldvalue,newvalue)
				print('same',oldvalue,newvalue)
			end 
		end)
	end 
end)