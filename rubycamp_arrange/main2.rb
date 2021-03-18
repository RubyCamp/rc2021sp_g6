require 'dxruby'
require 'singleton'

require_relative 'scene'

require_relative 'modules/map_chip'
require_relative 'modules/math_helper'

require_relative 'lib/component'
require_relative 'lib/director_base'
require_relative 'lib/popup_message'
require_relative 'lib/map_base'

require_relative 'scenes/game/director'
require_relative 'scenes/game/map'
require_relative 'scenes/game/player'

require_relative 'scenes/map_editor/director'
require_relative 'scenes/map_editor/map'
require_relative 'scenes/map_editor/chip_pallet'
require_relative 'scenes/map_editor/button'

Window.width = 1024
Window.height = 768
Window.caption = "RubyCamp 2021SP Sample1"
time_counter = 0
second = 0

Scene.add(Game::Director.new, :game)
Scene.add(MapEditor::Director.new, :map_editor)
Scene.move_to(:game)

Window.loop do
  break if Input.key_push?(K_ESCAPE)
  Scene.move_to(:game) if Input.key_push?(K_G)
  Scene.move_to(:map_editor) if Input.key_push?(K_M)
  Scene.play
  time_counter += 1
  if time_counter == 60 then
    second += 1
  end
end