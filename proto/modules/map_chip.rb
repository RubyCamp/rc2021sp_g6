module MapChip
  PATH = "images/maptile.png"
  WEIGHT_PATH = "data/chip.dat"
  CHIP_SIZE = 32

  # マップチップのパレットを一括ロード
  def load_chips
    temp = Image.load(PATH)
    x = temp.width / CHIP_SIZE
    y = temp.height / CHIP_SIZE
    Image.load_tiles(PATH, x, y)
  end

  def load_chip_weights
    data = File.read(WEIGHT_PATH)
    weights = []
    data.split(/\n/).each do |line|
      weights << line.chomp.split(/\s*,\s*/)
    end
    weights
  end

  # Window座標系からマップ座標系へ座標変換（Coordinate transformation）を行う
  def ct_window_to_map(origin_pos, current_pos, map_root_pos = [0, 0])
    relative_win_x = current_pos[0] - origin_pos[0]
    relative_win_y = current_pos[1] - origin_pos[1]
    map_x = (map_root_pos[0] + relative_win_x).to_i / CHIP_SIZE
    map_y = (map_root_pos[1] + relative_win_y).to_i / CHIP_SIZE
    [map_x, map_y]
  end

  # マップの二次元座標からチップタイルの位置情報を得る
  def convert_pos_to_chip_number(map_pos, image)
    x_split_size = image.width.to_i / CHIP_SIZE
    map_pos[1].to_i * x_split_size + map_pos[0].to_i
  end
end