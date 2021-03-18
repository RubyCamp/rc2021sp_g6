module MapEditor
  # マップに配置するチップのパレット
  class ChipPallet < Component
    include Singleton
    include MapChip

    attr_accessor :x, :y, :chips, :pallet, :chip_num

    # 初期化
    def initialize(x = 50, y = 440)
      self.x, self.y = x, y
      @font = Font.new(24)
      self.chips = load_chips
      @chip_weights = load_chip_weights
      self.pallet = Image.load(MapChip::PATH)
      @weight_mark = RenderTarget.new(10, 10, C_RED)
      reset

      super(x, y, self.pallet.width, self.pallet.height)
    end

    # 選択されているチップ番号をデフォルトに戻す
    def reset
      self.chip_num = 0
    end

    # 1フレーム分の描画処理
    def draw
      Window.draw(self.x, self.y, self.pallet)
      @chip_weights.each_with_index do |line, y|
        line.each_with_index do |weight, x|
          if weight == '1'
            Window.draw(self.x + x * MapChip::CHIP_SIZE, self.y + y * MapChip::CHIP_SIZE, @weight_mark)
          end
        end
      end
      draw_current_chip
    end

    private

    # MapEditor::Directorクラスにマウスクリックイベントのリスナーを登録する
    def init_component
      # 左クリックイベントハンドラの登録
      Director.add_click_event(M_LBUTTON) do |pos|
        if in_area?(pos)
          mouse_left_clicked(pos)
        end
      end
    end

    # マウス左クリック完了時に呼ばれる
    def mouse_left_clicked(pos)
      map_pos = ct_window_to_map([self.x, self.y], pos)
      self.chip_num = convert_pos_to_chip_number(map_pos, self.pallet)
    end

    # 現在選択されているチップ画像を表示する
    def draw_current_chip
      Window.draw_font(self.x + self.pallet.width + 20, self.y, "Selected: ", @font)
      Window.draw(self.x + self.pallet.width + 120, self.y, self.chips[self.chip_num])
    end
  end
end