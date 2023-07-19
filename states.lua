
-- i havent tested destroy method


--[[
this is a streamlined state module made to make changing states easier
lots of people use similar things, but i decided to write my own because im BORED 
and i need it for my upcoming project.

-- heres some example of module use --

local worldstate = states.new({
	fallbackstate = 'day';
	name = 'worldstate';
	
	states = {
		day = {
			priority = 1;

			const = function()
				print('day const')
			end,

			deconst = function()
				print('day deconst')
			end,
		};
		
		night = {
			priority = 1;

			const = function()
				print('night const')
			end,

			deconst = function()
				print('night deconst')
			end,
		}
	}
})

]]

local class = {
	console = true
}

local function log(str)
	if class.console then
		warn(str)
	end
end


function class.new(args: {name: string, fallbackstate: string, states: {[any]: {priority: number; const: (any) -> (), deconst: (any) -> ()}}})
	local obj = {
		currentstate = nil;
	}
	
	local statechanged = Instance.new('BindableEvent')
	local destroying = Instance.new('BindableEvent')
	
	
	obj.destroying = destroying.Event
	obj.statechanged = statechanged.Event
	
	function obj.disable()
		args.states[obj.currentstate].deconst()
	end
	
	function obj.enable()
		args.states[obj.currentstate].const()
	end
	
	function obj.setstate(a)
		local currentstate = args.states[obj.currentstate]
		local desired = args.states[a]
		
		assert(desired, '[obj.setstate]: passed argument for [KEY] was not found inside the given states')
		if currentstate == desired then log('[obj.setstate]: given state is already set') return end
		
		
		if currentstate.priority < desired.priority or currentstate.priority == desired.priority then
			obj.disable()

			obj.currentstate = a
			obj.enable()

			statechanged:Fire(a)
		else
			log('[obj.setstate]: denied due to [lastpriority] greaterthan [newpriority]')
		end
	end
	
	function obj.destroy()
		destroying:Fire()
		
		obj.disable()

		statechanged:Destroy()
		destroying:Destroy()

		table.clear(obj)
		args = nil
	end
	
	
	obj.currentstate = args.fallbackstate
	obj.enable()
	
	return obj
end


return class
