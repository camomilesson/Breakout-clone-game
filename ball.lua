Ball = Entity:extend()

function Ball:new(x, y)
  Ball.super.new(self, x, y)
  self.speed = 300
  self.angle = math.random(25, 75) / -100 * math.pi
  self.radius = 10
  self.rotation = 0
  self.rotation_speed = 0.02
  table.insert(balls, self)
end


function Ball:update(dt)    
  self.x = self.x + self.speed * math.cos(self.angle) * dt
  self.y = self.y + self.speed * math.sin(self.angle) * dt
  self.rotation = self.rotation + self.rotation_speed

  if self.x < self.radius / 2 then
    self.x = self.radius / 2
    self.angle = math.pi - self.angle
  elseif self.x > love.graphics.getWidth() - self.radius / 2 then
    self.x = love.graphics.getWidth() - self.radius / 2
    self.angle = math.pi - self.angle
  end

  if self.y < 5 then
    self.y = 5
    self.angle = - self.angle
  end 
  
  self:resolveCollision(bumper)
  
  for i, v in ipairs(bricks) do
    self:resolveCollision(v)
    
    if self:checkCollision(v) then
      v.health = v.health - 1
      score = score + 10
    end
    
    if v.health < 1 then
      Brick:destroy(i)
    end
  end
end


function ball_start()
  ball.speed = 300
  ball.rotation_speed = 0.02
end


function Ball:draw()
  love.graphics.draw(ball_image, self.x, self.y, self.rotation, self.radius * 2 / ball_image:getWidth(), self.radius * 2 / ball_image:getHeight(), ball_image:getWidth() / 2, ball_image:getHeight() / 2)
end


function Ball:checkPosition(e)
  local horizontalPostition = "TBD"
  local verticalPosition = "TBD"
  local position = "TBD"
  
  if self.x < e.x then
    horizontalPostition = "left"
  elseif self.x > e.x + e.width then
    horizontalPostition = "right"
  else
    horizontalPostition = "level"
  end
  
  if self.y < e.y then
    verticalPosition = "top"
  elseif self.y > e.y + e.height then
    verticalPosition = "bottom"
  else
    verticalPosition = "level"
  end
  
  if horizontalPostition == "left" then
    if verticalPosition == "top" then
      position = "NW"
    elseif verticalPosition == "bottom" then
      position = "SW"
    elseif verticalPosition == "level" then
      position = "W"
    end
  elseif horizontalPostition == "right" then
    if verticalPosition == "top" then
      position = "NE"
    elseif verticalPosition == "bottom" then
      position = "SE"
    elseif verticalPosition == "level" then
      position = "E"
    end    
  elseif horizontalPostition == "level" then
    if verticalPosition == "top" then
      position = "N"
    elseif verticalPosition == "bottom" then
      position = "S"
    elseif verticalPosition == "level" then
      position = "inside"
    end    
  end
  
  return position
end


function Ball:checkCollision(e)
  local position = self:checkPosition(e)
  local distance = self:getDistance(e)
  
  local diagonal = math.sqrt((e.width / 2) ^ 2 + (e.height / 2) ^ 2)
  
  if position == "N" then
    if self.y + self.radius >= e.y then
      return true
    end
  elseif position == "S" then
    if self.y - self.radius <= e.y + e.height then
      return true
    end
  elseif position == "E" then
    if self.x - self.radius <= e.x + e.width then
      return true
    end
  elseif position == "W" then
    if self.x + self.radius >= e.x then
      return true
    end
  else
    local corner = {}
    if position == "NW" then
      corner.x = e.x
      corner.y = e.y
    elseif position == "NE" then
      corner.x = e.x + e.width
      corner.y = e.y
    elseif position == "SW" then
      corner.x = e.x
      corner.y = e.y + e.height
    elseif position == "SE" then
      corner.x = e.x + e.width
      corner.y = e.y + e.height
    elseif position == "inside" then
      return true
    end
    
    local cornerDistance = math.sqrt((self.x - corner.x) ^ 2 + (self.y - corner.y) ^ 2)
    if cornerDistance < self.radius then
      return true
    end 
  end
  return false
end


function Ball:resolveCollision(e)
  local position = self:checkPosition(e)
  local collision = self:checkCollision(e)
  
  if collision then
    if position == "N" or position == "S" then
      self.angle = -self.angle
    elseif position == "E" or position == "W" then
      self.angle = math.pi - self.angle
    else
      local corner = {}
      if position == "NW" then
        corner.x = e.x
        corner.y = e.y
      elseif position == "NE" then
        corner.x = e.x + e.width
        corner.y = e.y
      elseif position == "SW" then
        corner.x = e.x
        corner.y = e.y + e.height
      elseif position == "SE" then
        corner.x = e.x + e.width
        corner.y = e.y + e.height
      elseif position == "inside" then
        self.x = e.x + e.width / 2
        self.y = e.y - self.radius
        self.angle = -self.angle
        return
      end
      local impactAngle = math.atan2(math.abs(self.x - corner.x), math.abs(self.y - corner.y))
      self.angle = self.angle - 2 * impactAngle
    end
  end
end


function Ball:getDistance(e)
  local horizontalDistance = self.x - (e.x + e.width / 2)
  local verticalDistance = self.y - (e.y + e.height / 2)
  
  local a = horizontalDistance ^2
  local b = verticalDistance ^2
  
  local c = a + b
  
  local distance = math.sqrt(c)
  return distance
end