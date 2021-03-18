module MapEditor
  # マップエディタ用マップ領域
  class Map < MapBase
    include MathHelper

    DRAG_SENSITIVITY_X = 6 # マウスドラッグ感度（X軸）
    DRAG_SENSITIVITY_Y = 6 # マウスドラッグ感度（Y軸）

    private

    # 本コンポーネント固有の初期化処理
    def init_component
      add_clicked_listener
      add_dragged_listener
      add_dragging_listener
    end

    # MapEditor::Directorクラスにマウスクリックイベントのリスナーを登録する
    def add_clicked_listener
      # 左クリックイベントハンドラの登録
      Director.add_click_event(M_LBUTTON) do |pos|
        if in_area?(pos)
          mouse_left_clicked(pos)
        end
      end

      # 右クリックイベントハンドラの登録
      Director.add_click_event(M_RBUTTON) do |pos|
        if in_area?(pos)
          mouse_right_clicked(pos)
        end
      end
    end

    # MapEditor::Directorクラスにマウスドラッグ終了イベントのリスナーを登録する
    def add_dragged_listener
      # 右ドラッグイベントハンドラの登録
      Director.add_dragged_event(M_RBUTTON) do |drag_pos, drop_pos|
        if in_area?(drag_pos)
          mouse_right_dragged(drag_pos, drop_pos)
        end
      end
    end

    # MapEditor::Directorクラスにマウスドラッグ中イベントのリスナーを登録する
    def add_dragging_listener
      Director.add_dragging_event(M_LBUTTON) do |pos|
        if in_area?(pos)
          mouse_left_dragging(pos)
        end
      end
    end

    # マウス左クリック完了時に呼ばれる
    def mouse_left_clicked(pos)
      stop_scroll # スクロールを止める
      draw_map_chip(pos)
    end

    # マウス右クリック完了時に呼ばれる
    def mouse_right_clicked(pos)
      stop_scroll # スクロールを止める
      ChipPallet.instance.reset # 選択中のチップ番号をデフォルト値に戻す
    end

    # マウス右ドラッグ完了時に呼ばれる
    # - ベクトル方向の逆向きに、ベクトルのX成分・Y成分にドラッグ感度係数を掛けた値を速度としてスクロール実行する
    def mouse_right_dragged(drag_pos, drop_pos)
      norm, rad = calc_vector(drag_pos, drop_pos)
      speed_x = norm * Math.cos(rad) / (@canvas.width / DRAG_SENSITIVITY_X)
      speed_y = norm * Math.sin(rad) / (@canvas.height / DRAG_SENSITIVITY_Y)
      self.dir_x = (speed_x / speed_x.abs).to_i if speed_x != 0
      self.dir_y = (speed_y / speed_y.abs).to_i if speed_y != 0
      self.sp_x = speed_x.to_i.abs
      self.sp_y = speed_y.to_i.abs
    end

    # マウス左ボタンのドラッグ中に呼ばれる
    def mouse_left_dragging(pos)
      # 現在選択中のチップで連続的に描画する
      draw_map_chip(pos)
    end

    # 現状のスクロールの停止
    def stop_scroll
      if self.sp_x != 0 || self.sp_y != 0
        self.sp_x = 0
        self.sp_y = 0
      end
    end

    # 引数で渡されたWindow上の絶対座標から、その位置に該当するマップチップを選択中のものと入れ替える
    def draw_map_chip(pos)
      x, y = convert_win_to_map(pos)
      change_chip(x, y, ChipPallet.instance.chip_num)
    end
  end
end
