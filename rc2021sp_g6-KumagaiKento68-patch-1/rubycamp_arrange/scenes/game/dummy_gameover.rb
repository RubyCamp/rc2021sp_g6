#仮のゲームオーバー画面。後で変更の可能性あり
module DummyEnding
    class DummyDirector
        def initialize
            @font = Font.new(24)
        end
    
        def reload
        end
    
        #変更点　Gを押したらゲームに戻る。出来ればゲームではなくオープニング画面に戻りたい
        def play
            Window.draw_font(100, 70, "Game Over!", @font)
            Window.draw_font(100, 100, "push G to back to game", @font)
            if Input.key_push?(K_G) then
                Scene.move_to(:game)
            end
        end
    end
end