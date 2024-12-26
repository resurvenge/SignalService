local SignalService = {
	 SIGNALS = {}
}
SignalService.__index = SignalService
-- Made this for fun because I was watching a video on GoodSignal and I liked it but I seriously do not like using community stuff unless its nessesary

function SignalService.new(args) 
	   local mySignal = setmetatable({}, SignalService)
	   mySignal.TYPE = "Connection"
	   if args and args.Name then
			  mySignal.Name = args.Name
	   end
	   table.insert(SignalService.SIGNALS, mySignal)
	   return mySignal
end

function SignalService:GlobalTrigger(EventName, ...)
	  for _, obj in pairs(SignalService.SIGNALS) do
			  if obj.TYPE == "Connection" and obj.Name == EventName then
					  obj:Emit(...)
			  end
	  end
end


function SignalService:GlobalDisconnect(EventName, ...)
	for _, obj in pairs(SignalService.SIGNALS) do
		if obj.TYPE == "Connection" and obj.Name == EventName then
			 obj:Disconnect()
		end
	end
end

function SignalService.DisconnectAll() 
	   for _, obj in pairs(SignalService.SIGNALS) do
			 if obj and obj.TYPE == "Connection" then
				  obj:Disconnect()
				  print("DISCONNECTED OBJECT: ", obj)
			 end
	   end
end

function SignalService:Disconnect() 
	if self and self.ActiveConnection then self.ActiveConnection = nil end
end


function SignalService:Connect(func) 
	   if not self.ActiveConnection then
			   self.ActiveConnection = func
	   else
			 self:Disconnect()
			 self.ActiveConnection = func
			 print("Disconnected")
	   end
end


function SignalService:Emit(...)
	  if self and self.ActiveConnection then self.ActiveConnection({...}) else print("Signal not found.") end
end

function SignalService:Once(...)
	  if self and self.ActiveConnection then self.ActiveConnection({...}) self:Disconnect() end
end



return SignalService
