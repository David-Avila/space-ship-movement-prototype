import "listUtil"

//************************* TIMED SPRITE
TimedSprite = new Sprite
TimedSprite.despawnTime = 0
TimedSprite.destroyed = false
TimedSprite.init = function(duration = 0.5)
	self.despawnTime = time + duration
	display(4).sprites.push self
end function
TimedSprite.update = function
	if time > self.despawnTime then 
		self.destroy
	end if
end function
TimedSprite.destroy = function
	display(4).sprites.removeVal self
end function
