module Ending
    class Director
        def initialize
            @font = Font.new(50, "MS ゴシック")
            @font2 = Font.new(30, "MS ゴシック")
        end
    
        def reload
        end
    
        def play
            Window.bgcolor = C_BLACK
            Window.draw_font(300, 300, "Game Over", @font ,color: C_RED)
            Window.draw_font(400, 383, "Restart : R_key", @font2 ,color: C_RED)
            Scene.move_to(:opening) if Input.key_push?(K_R)
        end
    end
end
