module Opning
    class Director
        def initialize
            @font = Font.new(60, "MS ゴシック")
            @font2 = Font.new(30, "MS ゴシック")
           # image = Image.load('player.png')
        end
    
        def reload
        end
    
        def play
            Window.draw(100, 100, @image)
            Window.bgcolor = C_GREEN
            Window.draw_font(300, 300, "GAME START", @font, color: C_WHITE)
            Window.draw_font(400, 384, "Push s key.", @font2, color:  C_WHITE)
            Scene.move_to(:game) if Input.key_push?(K_S)
        end
    end
end