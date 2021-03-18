module Clear
    class Director
        def initialize
            #文字のフォント、サイズ
            @font = Font.new(50, "MS ゴシック")
            @font2 = Font.new(30, "MS ゴシック")
            @image = Image.load('images/花火.png')
        end
    
        def reload
        end
    
        def play
            #画面の描画
            Window.draw_scale(500, 320, @image, 10, 10)
            @image.set_color_key(C_WHITE)
            Window.bgcolor = C_BLUE

            #文字の描画
            Window.draw_font(350, 100, "GAME CLEAR !!", @font, color: C_WHITE)
            Window.draw_font(360, 550, "QUIT GAME : ESC_key", @font2 ,color:  C_WHITE)
            Window.draw_font(380, 300, "Score : #{$point} ",@font,color:C_WHITE)
            Scene.move_to(:opening) if Input.key_push?(K_R)
        end
    end
end