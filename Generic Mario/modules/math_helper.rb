module MathHelper
  # 二次元座標空間上の任意の2点からなるベクトルの長さと角度を計算する
  def calc_vector(pos1, pos2)
    x1, y1 = pos1
    x2, y2 = pos2
    norm = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))
    rad = Math.atan2(y2 - y1, x2 - x1)
    [norm, rad]
  end
end
