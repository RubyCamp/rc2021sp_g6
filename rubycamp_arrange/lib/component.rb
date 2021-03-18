# 全ての画面上の構成要素の親となるクラス
class Component
  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height

    # コンポーネント毎の初期化用メソッド呼び出し
    init_component
  end

  private

  # コンポーネント固有の初期化処理に使用する
  def init_component
  end

  # 引数で指定された座標（配列）が、自身の領域内にあるかどうかを判定
  def in_area?(pos)
    (@x..(@x + @width)).include?(pos[0].to_i) &&
      (@y..(@y + @height)).include?(pos[1].to_i)
  end
end