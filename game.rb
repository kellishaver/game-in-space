require 'ruby2d'
require './lib/move_utils.rb'
require './lib/combat_utils.rb'

set(
  title: "GAME IN SPAAAACE!",
  width:800,
  height:600,
  background:'#000000',
  borderless: true
)

# Contains all lasers fired by the ship, so we can
# keep them updated, removed as-needed, and prevent
# too many from being fired at once.
@lasers = []

# SFX & Music
@pew = Sound.new('assets/pew.wav')

bg_music = Music.new('assets/music.mp3')
bg_music.volume = 30
bg_music.loop = true
bg_music.play

# Arbitrary speed that feels right for gameplay
SPEED = 5

# The maximum number of lasers from our rocket that
# we can have on-screen at once (mostly to prevent UI clutter,
# partially for performance)
MAX_LASERS = 3

# Render our main objects present at the start of the game

star_field = Image.new(
  "assets/bg.png",
  x: 0, y: 0, z: 1,
  width: 800, height: 600
)

rocket = Image.new(
  "assets/rocket.png",
  x: 375, y: 277, z: 10,
  width: 50, height: 50
)

# Rotation and movement for our rocket
#
# Spin with j and l,
# Move with i
on :key_held do |event|
  case event.key
  when "l"
    rocket.rotate += SPEED
  when "j"
    rocket.rotate -= SPEED
  when "i"
    move_toward_facing(rocket, rocket.rotate, SPEED)
    screen_glide(rocket)
  end
end

# Space bar go 'Pew! Pew!'
on :key_up do |event|
  if event.key == "space"
    maybe_fire_laser(rocket)
  end
end

# The game loop
update do
  # Iterate over all of our lasers and do laser-y things
  # like move, vanish when out of range, and hit stuff 
  @lasers.each do |laser|
    move_toward_facing(laser[:pew], laser[:direction], SPEED*3)
    clean_up_old_lasers(laser)
    # TODO: blow stuff up
  end
end

show