module MapEditor
  # シーン管理用ディレクタークラス
  class Director < DirectorBase
    # マウスクリックイベントを受け取るProcオブジェクトをボタン毎に格納する
    @@click_events = {
      M_LBUTTON => [],
      M_RBUTTON => []
    }

    # マウスドラッグ完了イベントを受け取るProcオブジェクトをボタン毎に格納する
    @@dragged_events = {
      M_LBUTTON => [],
      M_RBUTTON => []
    }

    # マウスドラッグ中イベントを受け取るProcオブジェクトをボタン毎に格納する
    @@dragging_events = {
      M_LBUTTON => [],
      M_RBUTTON => []
    }

    # 初期化
    def initialize
      @map = Map.new(50, 50, 2, 5, 5)
      @drag_pos = {
        M_LBUTTON => nil,
        M_RBUTTON => nil
      }
      @font = Font.new(28)
      @chip_pallet = ChipPallet.instance
      sb_x = ChipPallet.instance.x + ChipPallet.instance.pallet.width + 180
      @save_popup = PopupMessage.new("保存中...")
      @save_button = Button.new(sb_x,440, 150, 50, "Save!") do |_|
        @save_popup.life = 60
        @map.save
      end
    end

    # Scene遷移時に自動呼出しされる規約メソッド
    def reload
    end

    # 画面領域のクリックイベントに対するリスナーを追加
    def self.add_click_event(button, &block)
      @@click_events[button] << block
    end

    # 画面領域のドラッグ終了イベントに対するリスナーを追加
    def self.add_dragged_event(button, &block)
      @@dragged_events[button] << block
    end

    # 画面領域のドラッグ中イベントに対するリスナーを追加
    def self.add_dragging_event(button, &block)
      @@dragging_events[button] << block
    end

    # 1フレーム描画
    def play
      detect_mouse_event(M_LBUTTON)
      detect_mouse_event(M_RBUTTON)
      @map.update
      @map.draw
      title_draw
      @chip_pallet.draw
      @save_button.draw
      @save_popup.draw
    end

    private

    # タイトル文字列描画
    def title_draw
      Window.draw_font(50, 5, "Map Editor", @font)
    end

    # マウスイベント検知
    # 引数で指定されたマウスボタン定数に対するクリック・ドラッグを識別し、それぞれ定められたイベントハンドラを実行する
    def detect_mouse_event(button)
      # ドラッグ開始イベントの検出
      if Input.mouse_down?(button) && !@drag_pos[button]
        @drag_pos[button] = [Input.mouse_x, Input.mouse_y]
      end

      # ドラッグ中イベントの検出
      if Input.mouse_down?(button) && @drag_pos[button]
        dragging_pos = [Input.mouse_x, Input.mouse_y]
        if @drag_pos[button] != dragging_pos
          @@dragging_events[button].each do |proc|
            proc.call(dragging_pos)
          end
        end
      end

      # ドロップイベントの検出
      if Input.mouse_release?(button) && @drag_pos[button]
        drop_pos = [Input.mouse_x, Input.mouse_y]
        if @drag_pos[button] == drop_pos
          @@click_events[button].each do |proc|
            proc.call(@drag_pos[button])
          end
        else
          @@dragged_events[button].each do |proc|
            proc.call(@drag_pos[button], drop_pos)
          end
        end
        @drag_pos[button] = nil
      end
    end
  end
end
