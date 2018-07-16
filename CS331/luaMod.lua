--mod example class "Animal"

local animal = {}

function animal.howdy() 
	io.write("Howdy pardna \n")
end

animal.beast = {}

function animal.beast.stomp(self) 
	io.write("The beastly blood driven beast has stomped on your mothers house! \n")
end

function animal.beast.__index(tbl, key)
	return animal.beast[key]
end

function animal.beast.new()
	local obj = {}
	obj.sound = "<silence>"
	setmetatable(obj, animal.beast)
	return obj
end

function animal.beast.setSound(self, sound)
	self.sound = sound	
end

function animal.beast.makeSound(self)
	io.write(self.sound.."!!!!! \n")
end

return animal


