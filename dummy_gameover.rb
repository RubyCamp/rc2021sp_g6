#仮のゲームオーバー画面。後で変更の可能性あり
module DummyEnding
    class DummyDirector
        def initialize
            @font = Font.new(24)
        end
    
        def reload
        end
    
        def play
            Window.draw_font(100, 100, "Game Over!", @font)
        end
    end
end