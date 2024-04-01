Powerup = Entity:extend()

function Powerup:new(x, y, type)
  Powerup.super.new(self, x, y)
  self.radius = 10
  self.type = type
  self.speed = 100
  self.status = "active"
  table.insert(powerups, self)
end

function Powerup:update(dt)
  self.y = self.y + self.speed * dt
  
  if magnet_effect > 0 then
    if bumper.x + bumper.width / 2 > self.x then
      magnet_direction = 1
    else
      magnet_direction = -1
    end
    
    self.x = self.x + self.speed * dt * magnet_direction
    magnet_effect = magnet_effect - 1
  end
end

function Powerup:activate()
  if self.type == "W" then
    bumper.x = bumper.x - 15
    bumper.width = bumper.width + 30
  elseif self.type == "B" then
    i = math.random(1, #balls)
    Ball(balls[i].x, balls[i].y)
  elseif self.type == "T" and bumper.speed < 700 then
    bumper.speed = bumper.speed + 30
  elseif self.type == "M" then
    magnet_effect = 1000
  end
  self.status = "used"
end

function Powerup:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.x, self.y, self.radius)
  love.graphics.setColor(palette[7])
  love.graphics.circle("fill", self.x, self.y, self.radius - 1)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf(self.type, self.x - self.radius, self.y - self.radius / 1.5, self.radius  * 2, "center")
end
