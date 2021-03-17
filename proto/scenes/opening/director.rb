module Opning
    class Director
        def initialize
            #文字のフォント、サイズ
            @font = Font.new(50, "MS ゴシック")
            @font2 = Font.new(30, "MS ゴシック")
            @image = Image.load('images/player2.png')
            @image2 = Image.load('images/城.png')
        end
    
        def reload
        end
    
        def play
            #空と地面の描画
            Window.draw_box_fill(0, 0, Window.width, 500, [128, 255, 255])
            Window.draw_box_fill(0, 500, Window.width, Window.height, [185, 135, 11])

            #キャラクター
            Window.draw_scale(250, 380, @image, 4, 4)
            @image.set_color_key(C_WHITE)
            Window.draw_scale(800, 310, @image2, 5, 5)
            @image2.set_color_key(C_WHITE)

            Window.bgcolor = C_BLUE

            #タイトル文字
            Window.draw_font(350, 100, "GAME START", @font, color: C_YELLOW)
            Window.draw_font(400, 184, "Push s key", @font, color:  C_YELLOW)

            Window.draw_font(400, 300, "左:← key   右:→ key", @font2, color:  C_BLACK)
            Window.draw_font(400, 330, "ジャンプ:SPECE key", @font2, color:  C_BLACK)
            Scene.move_to(:game) if Input.key_push?(K_S)
        end
    end
end