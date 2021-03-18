module Game
  # ゲームマップ
  class Map  < MapBase
    WALL_CHIP_WEIGHT = 1  # 通過不可マップチップの重み番号

    attr_accessor :scroll_direction_x, :scroll_direction_y

    # 初期化
    def initialize(root_x, root_y, speed = nil, mx = nil, my = nil)
      super
      @chip_weights = load_chip_weights
    end

    # マップスクロール方向を規定する
    def set_scroll_direction(sdx, sdy)
      self.scroll_direction_x, self.scroll_direction_y = sdx, sdy
    end

    # 1フレーム分のマップスクロール処理
    def update(ix = nil, iy = nil, speed_x = nil, speed_y = nil)
      ix ||= self.scroll_direction_x
      iy ||= self.scroll_direction_y
      x, y = convert_win_to_map([@mx + ix, @my + iy])
      if y > @map_height - WINDOW_Y_SIZE - 2
        iy = 0
      end

      super
    end

    # 引数で指定されたチップ番号の重み情報（通過可能／不能）を返す
    def get_chip_weight(chip_num)
      cy = chip_num.to_i / MapChip::CHIP_SIZE
      cx = chip_num.to_i % MapChip::CHIP_SIZE
      @chip_weights[cy][cx].to_i
    end

    private

    # 親クラスで定義されているコンポーネント初期化用メソッド
    # ※ 本クラスでは不要なので空（オーバーライドしないと例外を出すようにしているので定義は必要）
    def init_component
    end
  end
end
