# If we don't have too many aliens on screen,
# add another one!
def maybe_spawn_alien(ship_x, ship_y)
  if @aliens.length < MAX_ALIENS
    x = spawn_x
    y = spawn_y
    alien = Sprite.new(
      "assets/alien.png",
      clip_width: 30,
      time: 200,
      loop: false,
      x: x,
      y: y,
      z: 9,
      width: 30,
      height: 30,
      rotate: set_facing(x,y,ship_x,ship_y)
    )
    alien.play
    @aliens << alien
  end
end

# We always want to spawn aliens at the endges
# of the screen
def spawn_x
  [
    rand(100..200),
    rand((Window.width-200)..Window.width-100)
  ].shuffle.first
end

def spawn_y
  [
    rand(100..200),
    rand((Window.height-200)..Window.height-100)
  ].shuffle.first
end

def rotate_some_aliens
  # Rotate half the aliens on screen
  @aliens.sample(@aliens.length/2).each do |alien|
    alien.rotate = rand(0..360)
  end
end

def clean_up_old_aliens(obj)
  # If the laser's gone out of bounds, we remove it from the laser 
  # array and the stage.
  if obj.x < 0 || obj.y < 0 || 
     obj.x > Window.width || obj.y > Window.height
    
    @aliens.delete(obj)
    obj.remove
  end
end

# See if we hit the ship and then:
#
# 1. Remove the alien
# 2. Reduce lives by 1
# 3. Flash the screen red.
def handle_ship_collision(alien, ship)
  if ship.contains? alien.x, alien.y
    @alarm.play
    @lives -= 1

    @aliens.delete(alien)
    alien.remove

    @overlay.opacity = 0.5
  end
end