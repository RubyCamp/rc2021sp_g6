module Ending
    class Director
        def initialize
            #文字のフォント、サイズ
            @font = Font.new(70, "丸 ゴシック")
            @font2 = Font.new(40, "MS ゴシック")
            @image = Image.load('images/墓.png')
        end
    
        def reload
        end
    
        def play
            #画像の描画
            Window.bgcolor = C_BLACK
            Window.draw_scale(500, 320, @image, 6, 6)
            @image.set_color_key(C_WHITE)

            #文字の描画
            Window.draw_font(300, 150, "GAME OVER", @font ,color: C_RED)
            Window.draw_font(350, 460, "RESTRAT : R_key", @font2 ,color: C_RED)
            Scene.add(Game::Director.new, :game) #初期位置の初期化
            Scene.move_to(:opening) if Input.key_push?(K_R)
        end
    end
end