require 'ruby2d'
require './lib/move_utils.rb'
require './lib/alien_utils.rb'
require './lib/laser_utils.rb'

set(
  title: "GAME IN SPAAAACE!",
  width:800,
  height:600,
  background:'#000000',
  borderless: true
)

# Arrays to contain various objects, so we can
# keep them updated, removed as-needed, and prevent
# too many from being on screen at once.
@lasers = []
@aliens = []

@score = 0
@lives = 3

# SFX & Music
@pew = Sound.new('assets/pew.wav')
@boom = Sound.new('assets/boom.wav')

bg_music = Music.new('assets/music.mp3')
bg_music.volume = 30
bg_music.loop = true
bg_music.play

# Arbitrary speed that feels right for gameplay
SPEED = 5

# The maximum numbers of various objects that we can
# have on-screen at once (mostly to prevent UI clutter,
# partially for performance)
MAX_LASERS = 3
MAX_ALIENS = 10

# Render our main objects present at the start of the game

star_field = Image.new(
  "assets/bg.png",
  x: -800, y: -600, z: 1,
  width: 2400, height: 1800
)

scoreboard = Text.new(
  @score,
  x: 100, y: 10,
  size: 16,
  color: '#ffffff',
  z: 100
)

lifecard = Text.new(
  @lives,
  x: 40, y: 10,
  size: 16,
  color: '#ffffff',
  z: 100
)

rocket = Image.new(
  "assets/rocket.png",
  x: 375, y: 277, z: 10,
  width: 50, height: 50
)

life_marker = Image.new(
  "assets/rocket.png",
  x: 10, y: 10, z: 10,
  width: 20, height: 16
)

@overlay = Rectangle.new(
  x: 0, y: 0,
  width: 800, height: 600,
  color: '#ff0000',
  z: 99,
  opacity:0
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
    move_background(star_field, rocket.rotate, SPEED/2)
    screen_glide(rocket)
  end
end

# Space bar go 'Pew! Pew!'
on :key_up do |event|
  if event.key == "space" && @score > 0
    maybe_fire_laser(rocket)
  end
end

tick = 0

# The game loop
update do
  if @lives >= 0
    # Iterate over all of our lasers and do laser-y things
    # like move, vanish when out of range, and hit stuff 
    @lasers.each do |laser|
      move_toward_facing(laser[:pew], laser[:direction], SPEED*3)
      clean_up_old_lasers(laser)
      handle_hits(laser)
    end

    # Behaves a lot like lasers - itereate, clean, kill
    @aliens.each do |alien|
      move_toward_facing(alien, alien.rotate, SPEED/2)
      clean_up_old_aliens(alien)
      handle_ship_collision(alien, rocket)
    end

    # spawn aliens if there's room for them on the screen and rotate
    # half of them.
    maybe_spawn_alien(rocket.x, rocket.y)   if tick % 60 == 0
    rotate_some_aliens                      if tick % 120 == 0

    @overlay.opacity = 0  if @overlay.opacity > 0 && tick % 60 == 0

    # Update game states
    scoreboard.text = @score
    lifecard.text = @lives

    tick += 1
  else
    lifecard.remove
    @aliens.map{|a| a.remove}
    @lasers.map{|l| l[:pew].remove}
  end
end

show