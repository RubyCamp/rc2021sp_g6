# マップの基底クラス
class MapBase < Component
  WINDOW_X_SIZE = 25
  WINDOW_Y_SIZE = 12
  MAP_DAT_PATH = "data/map.dat"
  WALL_CHIP_NUM = 1

  attr_accessor :root_x, :root_y, :sp_x, :sp_y, :map_array, :chips, :dir_x, :dir_y, :width, :height

  include MapChip

  # 初期化
  # ※ 本サンプルではチップセットとマップデータのファイル名は固定とする。
  def initialize(root_x, root_y, speed = 1, mx = 0, my = 0)
    self.root_x = root_x
    self.root_y = root_y
    @mx = mx
    @my = my
    reload_map_array
    @map_width = self.map_array.first.size
    @map_height = self.map_array.size
    self.chips = load_chips
    self.sp_x = speed
    self.sp_y = speed
    self.dir_x = 0
    self.dir_y = 0
    @count_x = MapChip::CHIP_SIZE * self.sp_x
    @count_y = MapChip::CHIP_SIZE * self.sp_y
    self.width = WINDOW_X_SIZE * MapChip::CHIP_SIZE
    self.height = WINDOW_Y_SIZE * MapChip::CHIP_SIZE
    @canvas = RenderTarget.new(self.width, self.height, C_WHITE)

    super(self.root_x, self.root_y, self.width, self.height)
  end

  # マップ配列を再読み込みする
  def reload_map_array
    self.map_array = load_map_array(MAP_DAT_PATH)
  end

  # 外部からの更新受付
  # ix: X軸のスクロール方向を3値で与える（-1, 0, 1）
  # iy: Y軸のスクロール方向を3値で与える（-1, 0, 1）
  # scroll_speed: スクロールする速度を指定する。CHIP_SIZEを超える値は不可。
  def update(ix = nil, iy = nil, speed_x = nil, speed_y = nil)
    ix ||= self.dir_x
    iy ||= self.dir_y
    self.sp_x = speed_x if speed_x
    self.sp_y = speed_y if speed_y
    scroll_horizontal(ix) if ix != 0
    scroll_vertical(iy) if iy != 0
  end

  # 1フレーム分の描画を実行
  # draw_tileでマップ領域を一括描画（表示対象領域に対して最大でCHIP_SIZE分はみ出る）
  # はみ出た部分を表示しないようにマスキングするため、canvas（RenderTarget）に一旦描画し、はみ出た部分を切り捨てて
  # からWindowにレンダリングする。
  def draw
    @canvas.draw_tile(0, 0, self.map_array, self.chips,
                      @mx * MapChip::CHIP_SIZE - @count_x,
                      @my * MapChip::CHIP_SIZE - @count_y,
                      WINDOW_X_SIZE, WINDOW_Y_SIZE, 0)
    Window.draw(self.root_x, self.root_y, @canvas)
  end

  # 現時点のマップ配列を保存する
  def save
    File.open(MAP_DAT_PATH, "w") do |f|
      @map_array.each do |line|
        f.puts line.join(', ')
      end
    end
  end

  # Windowの絶対座標[win_pos]を、マップ座標に変換する
  # - pos: Window全体の座標系における選択ポイント座標
  # - offset_x/y: posの座標を本マップオブジェクトの原点（左上の絶対座標[@x, @y]）からの座標系に変換した値
  # - map_window_root_x/y: 現在本オブジェクトに描画されているマップ上のウィンドウ座標系の原点を表す
  # - map_x/y: マップチップ配列上の座標を表す
  # - x/y: スクロールのループに対応するため、マップチップ配列の縦幅・横幅で割った剰余値を求める
  def convert_win_to_map(win_pos)
    map_root_window_x = @mx * MapChip::CHIP_SIZE - @count_x
    map_root_window_y = @my * MapChip::CHIP_SIZE - @count_y
    map_x, map_y = ct_window_to_map([self.root_x, self.root_y], win_pos, [map_root_window_x, map_root_window_y])
    x = map_x % @map_width
    y = map_y % @map_height
    [x, y]
  end

  # マップ座標系の1点（CHIP_SIZEピクセルの正方形）の左上のWindow座標を返す
  def convert_map_to_win(map_pos)
    map_view_x = @mx * MapChip::CHIP_SIZE - @count_x
    map_view_y = @my * MapChip::CHIP_SIZE - @count_y
    map_win_x = map_pos[0] * MapChip::CHIP_SIZE
    map_win_y = map_pos[1] * MapChip::CHIP_SIZE
    [map_win_x - map_view_x + @x, map_win_y - map_view_y + @y]
  end

  # マップ配列上の[mx, my]位置のチップ番号を返す
  def get_chip_num(map_pos)
    if @map_array[map_pos[1]]
      if @map_array[map_pos[1]][map_pos[0]]
        return @map_array[map_pos[1]][map_pos[0]]
      end
    end
    WALL_CHIP_NUM
  end

  private

  # X軸方向のピクセル単位スクロールの実行
  def scroll_horizontal(ix)
    if ix > 0 # 右向き
      @count_x -= self.sp_x
      if @count_x < 0
        @count_x += MapChip::CHIP_SIZE * self.sp_x
        @mx += self.sp_x
      end
    else # 左向き
      @count_x += self.sp_x
      if @count_x >= MapChip::CHIP_SIZE + self.sp_x
        @count_x -= MapChip::CHIP_SIZE * self.sp_x
        @mx -= self.sp_x
      end
    end
  end

  # Y軸方向のピクセル単位スクロールの実行
  def scroll_vertical(iy)
    if iy > 0 # 下向き
      @count_y -= self.sp_y
      if @count_y < 0
        @count_y += MapChip::CHIP_SIZE * self.sp_y
        @my += self.sp_y
      end
    else # 上向き
      @count_y += self.sp_y
      if @count_y >= MapChip::CHIP_SIZE + self.sp_y
        @count_y -= MapChip::CHIP_SIZE * self.sp_y
        @my -= self.sp_y
      end
    end
  end

  # マップデータの一括ロード
  def load_map_array(path)
    result = []
    File.read(path).split(/\n/).each do |line|
      result << line.chomp.split(/\s*,\s*/).map(&:to_i)
    end
    result
  end

  # マップチップの置換
  def change_chip(x, y, chip_num)
    self.map_array[y][x] = chip_num.to_i
  end
end
