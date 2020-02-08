# If we don't have too many lasers on screen,
# add another one!
def maybe_fire_laser(obj)
  # Use an image here... 
  # We can't rotate basic shapes. ¯\_(ツ)_/¯
  if @lasers.length < MAX_LASERS
    @lasers << {
      pew: Image.new(
        "assets/laser.png",
        x: obj.x - 1 + obj.width/2,
        y: obj.y - 10 + obj.height/2,
        z: 9,
        width: 2,
        height: 20,
        rotate: obj.rotate
      ),    
      direction: obj.rotate
    }

    @pew.play
  end
end

def clean_up_old_lasers(obj)
  # If the laser's gone out of bounds, we remove it from the laser 
  # array and the stage.
  if obj[:pew].x < 0 || obj[:pew].y < 0 || 
     obj[:pew].x > Window.width || obj[:pew].y > Window.height
    
    @lasers.delete(obj)
    obj[:pew].remove
  end
end

# Check ot see if our laser hit anything and then do a lot of
# stuff if it ihas.
#
# 1. Play the 'boom' sound
# 2. Increase the score
# 3. Remove the laser and the alien
# 4. Reward an extra life if the score is high enough
def handle_hits(laser)
  @aliens.each do |alien|
    if alien.contains? laser[:pew].x, laser[:pew].y
      @boom.play
      @score += 10

      @lasers.delete(laser)
      laser[:pew].remove

      @aliens.delete(alien)
      alien.remove

      @lives += 1 if @score % 100 == 0
    end
  end
end
