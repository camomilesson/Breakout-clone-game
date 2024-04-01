Brick = Entity:extend()

function Brick:new(x, y)
  Brick.super.new(self, x, y)
  self.width = 40
  self.height = 10
  self.health = math.random(3)
  self.image = brick_images[math.random(#brick_images)]
  table.insert(bricks, self)
end

function Brick:update(dt)
  
end

function Brick:destroy(i)
  if math.random(1, 3) == 1 then
    Powerup(bricks[i].x + bricks[i].width/2, bricks[i].y + bricks[i].height/2, powerup_types[math.random(#powerup_types)])
  end
  table.remove(bricks, i)
end
  

function Brick:draw()
  love.graphics.setColor(palette[self.health])
  love.graphics.draw(self.image, self.x, self.y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight())
  love.graphics.setColor(1, 1, 1)
end
