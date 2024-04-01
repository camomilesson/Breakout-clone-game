function love.load()
  math.randomseed(os.time())
  
  Object = require "classic"
  require "entity"
  require "ball"
  require "bumper"
  require "brick"
  require "powerup"
  require "button"
  
  brick_images = {
    love.graphics.newImage("/images/image-removebg-preview1.png"),
    love.graphics.newImage("/images/image-removebg-preview2.png"),
    love.graphics.newImage("/images/image-removebg-preview3.png"),
    love.graphics.newImage("/images/image-removebg-preview4.png")
  }
  
  ball_image = love.graphics.newImage("/images/ball.png")
  menu_background = love.graphics.newImage("/images/menu_background.jpg")
  game_background = love.graphics.newImage("/images/game_background.jpg")
  
  
  palette = {
    {255/255, 200/255, 0},
    {255/255, 165/255, 0},
    {255/255, 130/255, 0},
    {255/255, 100/255, 0},
    {255/255, 75/255, 0},
    {255/255, 50/255, 0},
    {255/255, 25/255, 0}
  }
  
  states = {
    "menu",
    "game",
    "gameover",
    "win"
  }
  
  powerup_types = {"B", "W", "T", "M"}
  magnet_effect = 0
  
  state = states[1]
  
  font = love.graphics.newFont()
  love.graphics.setFont(font)
  
  buttonRestart = Button(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, "Try again")
  buttonMapRandom = Button(love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, "Random map")
  buttonMapHearts = Button(love.graphics.getWidth() / 2 + 100, love.graphics.getHeight() / 2, "Hearts map")
  
  bumper = Bumper(love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() - 15)
  score = 0
  
  powerups = {}
  balls = {}
  bricks = {}
  
  mapRandom = {}
  for i = 1, 20 do
    mapRandom[i] = {}
    for j = 1, 16 do
      mapRandom[i][j] = math.floor(math.random() + 0.5)
      if j == 1 or j == 16 then
        mapRandom[i][j] = 0
      end
    end
  end
  
  mapHearts = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0}, 
    {0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0}, 
    {0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0},
    {0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0}, 
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0}, 
    {0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0}, 
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0},
    {0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0}, 
    {0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
    {0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0}, 
    {0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0}, 
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0}, 
    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0}, 
    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0}, 
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0}, 
    {0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0}, 
    {0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
  }
end

function love.mousepressed(x, y, button)
  if state == "gameover" or state == "win" then
    if button == 1 then
      if x > buttonRestart.x - buttonRestart.width / 2 and x < buttonRestart.x + buttonRestart.width / 2
      and y > buttonRestart.y - buttonRestart.height / 2 and y < buttonRestart.y + buttonRestart.height / 2 then
        love.event.quit('restart')
      end
    end
  end

  if state == "menu" then
    if button == 1 then
      if x > buttonMapRandom.x - buttonMapRandom.width / 2 and x < buttonMapRandom.x + buttonMapRandom.width / 2
      and y > buttonMapRandom.y - buttonMapRandom.height / 2 and y < buttonMapRandom.y + buttonMapRandom.height / 2 then
          map = mapRandom
          fill_bricks(map)
          ball = Ball(love.graphics.getWidth() / 2, love.graphics.getHeight() - 26)
          ball.speed = 0
          ball.rotation_speed = 0
          state = states[2]
      end
    end
    
    if button == 1 then
      if x > buttonMapHearts.x - buttonMapHearts.width / 2 and x < buttonMapHearts.x + buttonMapHearts.width / 2
      and y > buttonMapHearts.y - buttonMapHearts.height / 2 and y < buttonMapHearts.y + buttonMapHearts.height / 2 then
          map = mapHearts
          fill_bricks(map)
          ball = Ball(love.graphics.getWidth() / 2, love.graphics.getHeight() - 26)
          ball.speed = 0
          ball.rotation_speed = 0
          state = states[2]
      end
    end
  end
end

function love.update(dt)
  if state == "game" then
    for i,v in ipairs(balls) do
      v:update(dt)
      if v.y > love.graphics.getHeight() + v.radius then
        table.remove(balls, i)
      end
    end
    
    bumper:update(dt)  
    
    if next(balls) == nil then
      state = states[3]
    end
    
    if next(bricks) == nil then
      state = states[4]
    end
    
    for i,v in ipairs(bricks) do
      v:update(dt)
    end
    
    for i,v in ipairs(powerups) do
      if v.status == "used" or v.y > love.graphics.getHeight() + v.radius then
        table.remove(powerups, i)
      end
      if v.y > bumper.y - v.radius and v.x > bumper.x and v.x < bumper.x + bumper.width then
        v:activate()
      end
      v:update(dt)
    end
  end
end

function love.draw()  
  if state == "menu" then
    love.graphics.draw(menu_background, 0, 0, 0, love.graphics.getWidth() / menu_background:getWidth(), love.graphics.getHeight() / menu_background:getHeight())
    buttonMapRandom:draw()
    buttonMapHearts:draw()
  end
  
  if state == "game" then
    love.graphics.draw(game_background, 0, 0, 0, love.graphics.getWidth() / menu_background:getWidth(), love.graphics.getHeight() / menu_background:getHeight())
    love.graphics.setColor(1, 1, 1)

    bumper:draw()
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Score: " .. score, 10, 10)
    love.graphics.setColor(1, 1, 1)
  
    for i,v in ipairs(balls) do
      v:draw()
    end
    
    for i,v in ipairs(bricks) do
      v:draw()
    end
    
    for i,v in ipairs(powerups) do
      v:draw()
    end
  end
  
  if state == "gameover" then
    love.graphics.draw(menu_background, 0, 0, 0, love.graphics.getWidth() / menu_background:getWidth(), love.graphics.getHeight() / menu_background:getHeight())
    buttonRestart:draw()
  end
  
  if state == "win" then
    love.graphics.draw(menu_background, 0, 0, 0, love.graphics.getWidth() / menu_background:getWidth(), love.graphics.getHeight() / menu_background:getHeight())
    buttonRestart.text = "You win!"
    buttonRestart:draw()
  end
end

function fill_bricks(map)
  bricks = {}
  for i = 1, #map do
    for j = 1, #map[i] do
      if map[i][j] == 1 then
        Brick(5 + 50 * (j - 1), 50 + 20 * (i - 1))
      end
    end
  end
end