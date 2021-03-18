require 'dxruby'
require 'singleton'

require_relative 'scene'

require_relative 'modules/map_chip'
require_relative 'modules/math_helper'

require_relative 'lib/component'
require_relative 'lib/director_base'
require_relative 'lib/popup_message'
require_relative 'lib/map_base'

require_relative 'scenes/opening/director'
require_relative 'scenes/game/director'
require_relative 'scenes/game/map'
require_relative 'scenes/game/player'
require_relative 'scenes/ending/director'
require_relative 'scenes/clear/director'


require_relative 'scenes/map_editor/director'
require_relative 'scenes/map_editor/map'
require_relative 'scenes/map_editor/chip_pallet'
require_relative 'scenes/map_editor/button'

Window.width = 1024
Window.height = 768
Window.caption = "RubyCamp 2021SP Sample1"

Scene.add(Opning::Director.new, :opening)
Scene.add(Game::Director.new, :game)
Scene.add(MapEditor::Director.new, :map_editor)
Scene.add(Ending::Director.new, :ending)
Scene.add(Clear::Director.new, :clear)
Scene.move_to(:opening)

Window.loop do
  break if Input.key_push?(K_ESCAPE)
  Scene.move_to(:game) if Input.key_push?(K_G)
  Scene.move_to(:ending) if Input.key_push?(K_C)
  Scene.move_to(:clear) if Input.key_push?(K_E)
  Scene.move_to(:map_editor) if Input.key_push?(K_M)
  Scene.move_to(:opening) if Input.key_push?(K_R)
  Scene.play
end