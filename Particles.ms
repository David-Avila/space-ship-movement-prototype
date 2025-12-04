import "Vec2"
import "listUtil"
import "mathUtil"

mt = @mathUtil.moveTowards

globals.Part = new Sprite
Part.image = file.loadImage("particle.png")
Part.x = 0
Part.y = 0

Part.speed = 150
Part.dir = null
Part.applyGravity = false
Part.gravity = -240
Part.randomize = true
Part.alpha = 255
Part.vel= null
Part.despawnTime = 0
Part.onTime = false
Part.color = null
Part.instances = []
Part.init = function(duration = 1)
	self.despawnTime = time + duration
	
	if self.randomize then
		self.x += rnd * 32 - 16
		self.y += rnd * 32 - 16
		
		self.speed *= rnd * 1 + 0.5
	end if
	
	self.vel = new Vec2.Vec2
	
	if self.applyGravity then
		self.vel.x = self.speed * sign(rnd - 0.5)
		self.vel.y = self.speed
	else
		self.vel.x = self.speed
		self.vel.y = 0
		self.vel.rotate(self.rotation)
	end if
	
	
	Part.instances.push self
	display(4).sprites.push self
end function
Part.update = function(dt)
	if time > self.despawnTime then 
		self.destroy
	end if
	
	if self.color != null then
		c = color.toList(self.color)
		
		self.tint = color.rgba(c[0], c[1], c[2], self.alpha)
	else
		self.tint = color.rgba(255,255,255,self.alpha)
	end if
	
	if self.applyGravity then
		self.vel.y = mt(self.vel.y, self.gravity, 10)
	end if
	
	if not self.onTime then
		if self.scale > 0 then
			self.scale -= 0.05
		else
			self.scale = 0
		end if
		
		self.alpha -= 10
		if self.alpha <= 0 then self.destroy
	end if
	
	
	self.x += self.vel.x * (dt)
	self.y += self.vel.y * (dt)
end function
Part.clear = function
	for p in Part.instances
		p.destroy
	end for
end function

Part.destroy = function
	Part.instances.removeVal self
	display(4).sprites.removeVal self
end function