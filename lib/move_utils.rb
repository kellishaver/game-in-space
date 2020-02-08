# Makes an object glide gracefuly along the edge of the
# screen, instead of just stopping or going out of boudns.
def screen_glide(obj)
  # Glide along the top/bottom
  if obj.y < obj.height / 2
    obj.y = obj.height / 2
  elsif obj.y > Window.height - obj.height * 1.5
    obj.y = Window.height - obj.height * 1.5
  end
  
  # Glide along the left/right
  if obj.x < obj.width / 2
    obj.x = obj.width / 2
  elsif obj.x > Window.width - obj.width * 1.5
    obj.x = Window.width - obj.width * 1.5
  end
end

# We pass in angle rather th an getting it from the object,
# so we can move things in directions that match the facing
# of other things, e.g. lasers matching ship angle at time
# of firing.
#
# Otherwise, the laser would follow ship rotation the entire
# time the laser was on screen.
def move_toward_facing(obj, angle, speed)
  angle = (angle - 90) * Math::PI / 180 # convert rad to deg
  obj.x += Math.cos(angle) * speed
  obj.y += Math.sin(angle) * speed
end
