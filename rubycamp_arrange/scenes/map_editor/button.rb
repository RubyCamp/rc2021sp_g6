module MapEditor
  # ボタンUI
  class Button < Component
    FONT_SIZE = 24

    # 初期化
    def initialize(x, y, w, h, label = "button", &block)
      @x, @y, @w, @h = x, y, w, h
      super(x, y, w, h)
      @label = label
      @callback = block
      @font = Font.new(FONT_SIZE)
      @image = Image.new(@w, @h, [200, 200, 200])
      label_width = @font.get_width(@label)
      @image.draw_font((@w - label_width) / 2, (@h / 2) - FONT_SIZE / 2, @label, @font, C_BLACK)
    end

    # 1フレーム分の描画処理
    def draw
      Window.draw(@x, @y, @image)
    end

    private

    # コンポーネント固有の初期化処理
    # ※ 本内容はinitializeに入れた場合動作しない点に注意
    # ※ 問題： 上記の理由を考えてみよう。
    def init_component
      Director.add_click_event(M_LBUTTON) do |pos|
        if in_area?(pos)
          @callback.call(pos)
        end
      end
    end
  end
end
