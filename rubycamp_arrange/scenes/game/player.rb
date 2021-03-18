module Game
    # プレイヤーキャラクタの挙動を制御する
    class Player
      include MathHelper # 他のプログラムと共用する数学系ヘルパーメソッドを読み込む
  
      SPEED_LIMIT_X = 24 # X軸方向の速度上限
      require_relative '../ending/director'
      Scene.add(Ending::Director.new, :gameover)
  
      # 初期化
      # 未考慮ポイント１: マップオブジェクトの参照を受け取って内部で保持している（マップと密結合している）。
      # 　　　　　　　　　マップとの結合をなるべく疎にしたいが、どのようなアプローチがありえるだろうか？
      def initialize(x, y, img, map)
        @x = x
        @y = y
        @image = img
        @image.set_color_key(C_WHITE) # 指定された画像のC_WHITE（白色）部分を透明化
        @map = map
        @g = 1
        @speed_x = 0
        @speed_y = 0
        @jump_flag = false
        @flag = false
        @jump_power = 0
        @speed = 4
      end
  
      # 1フレームにおけるプレイヤーの挙動更新
      # - Directorからキー入力のＸ方向の情報を受け取り、自身の挙動を制御する。
      # - インスタンス変数@dx, @dy に、当該フレームにおけるマップ上のＸ方向・Ｙ方向の移動量を計算し、移動量が確定した後に
      #   現在のプレイヤー座標に移動量を加算して位置を移動させる（当たり判定などによって移動をキャンセルする場合があるため）。
      #   その後、マップのスクロールに応じてプレイヤーの座標を微調整する（右スクロールの場合、壁にぶつかるなどして止まった
      #   場合、次のフレームで1スクロール単位分スクロール方向と逆に動かないと壁にめり込むことになるため）
      def update(input_x)
        @debug_boxes = [] # Directorで表示させるデバッグ用のマップチップの座標を保持する。デバッグ専用の変数
  
        # 1フレームの移動量計算に必要な各種変数を初期化
        init_variables
  
        # 以下、当該フレームにおける移動量（ @dx, @dy )を計算する
        detect_input(input_x) # キー入力方向に基づき、基本となる移動方向を決定する
        add_gravity_effect    # 重力に引かれて落下したり、重力に逆らってジャンプしたりという、鉛直方向の移動量を計算する
        check_map_interaction # 移動量を加算した場合における、マップチップとの当たり判定（未来位置の当たり判定）を行う
        validate_player_pos_limit # マップウィンドウ全体に対する画面外へのはみ出し判定を行う
  
        # 1フレーム分の確定移動量を現在位置に加算
        @x += @dx
        @y += @dy
  
        # プレイヤーの右面がマップチップと衝突した場合の移動量補正（スクロール分の移動量を打ち消す）
        if @collision_right
          @dx = -@map.scroll_direction_x
        end
  
        @debug_boxes # Directorに表示させたいデバッグボックスの座標群を返す
      end
  
      # プレイヤーキャラクタを現在位置に描画
      def draw
        Window.draw(@map.root_x + @x, @map.root_y + @y, @image)
      end
  
      # ジャンプの開始
      # 未考慮ポイント１： 敢えて空中でもジャンプ可能としている。空中ジャンプを禁止するにはどうすればよいか？
      # 未考慮ポイント２: 敢えて不自然なジャンプにとどめている。天井にぶつかったら止まるし、加速も減速も等速的。
      # 　　　　　　　　　例えば、天井にぶつかる直前にマップ自体を上スクロールするにはどうすればよいか？
      # 　　　　　　　　　例えば、自然な放物線を描くジャンプを実現するには、どの変数がどうなればよいか？
      # 未考慮ポイント３: 左右どちらかが壁に接している場合、ジャンプした瞬間の当たり判定でジャンプが止められてしまう。
      # 　　　　　　　　　これを防止するにはどのような解決策が考えられるか？
      def start_jump
        #フラグが立っていない & 床に足がついている
        if @jump_flag == false && @collision_bottom == true # && @flag == false 
          p "jump start"
          @jump_flag = true
          @jump_power = -20
        end
      end
  
      private
  
      # 1フレーム分の移動量計算に必要な変数の初期化
      def init_variables
        @dx = 0
        @dy = 0
        @input_x = 0
        @collisions = {
          right: false,
          left: false,
          top: false,
          bottom: false
        }
      end
  
      # キー入力検出
      def detect_input(input_x)
        @dx = 0
        @input_x = input_x
        @speed_x += input_x
        @speed_x = SPEED_LIMIT_X if @speed_x > SPEED_LIMIT_X
        @dx = @speed_x / 10.0 if @speed_x != 0
        @dx -= @map.scroll_direction_x if @input_x < 0  # スクロールと逆向きへの移動時は、スクロール分の移動量を打ち消す必要があるため。
      end
  
      # プレイヤーに重力分の移動を加算 & ジャンプ処理
      def add_gravity_effect    
                 
        p "@collision_bottom = #@collision_bottom"
        p "@jump_flag = #@jump_flag"
        p "@flag = #@flag"
        p "@y  = #@y"
        p "@dy = #@dy"
  
        # #start_jump
        # if @jump_flag == true && @collision_bottom == true
        #   p "jump"
        #   p ""        
        #   min_jump_power
        #上昇中
        if @collision_bottom == true && @jump_flag == true && @jump_power < 0 
          p "jump_up" 
          p ""        
          min_jump_power
        #下降中
        elsif @jump_flag == true && @collision_bottom == false
          p "jump_down"
          p ""
          min_jump_power
        #着地
        elsif @jump_flag == true && @collision_bottom == true
          p "stop"
          p "" 
          @dy += @speed
          @jump_flag = false
        elsif @collision_bottom == false
          p "fall"
          p ""
          @dy += @speed
        else
          p "else"
          p "" 
          @dy = 0
        end
  
        #@dxの処理
        if Input.x == 1
          @dx = @speed
        elsif Input.x == -1
          @dx = -1 * @speed
        else 
          @dx = 0        
        end
      end
  
  
      # @dx, @dy を加えたplayerの座標がマップ領域全体に対して移動可能かどうかを判定する
      # 未考慮ポイント１: マップチップと右面衝突した場合、そのまま放置するとマップ外にキャラクタが押し出される。
      # 　　　　　　　　　これはつまりプレイヤーがマップチップとマップ領域の壁に挟まれて「潰される」状況を意味するが、
      # 　　　　　　　　　本サンプルでは特にそれに対してアクションは取っていない。
      def validate_player_pos_limit
        tmp_x = @x + @dx
        tmp_y = @y + @dy
        stop_x_direction if tmp_x > @map.width - MapChip::CHIP_SIZE || tmp_x < 0
        stop_y_direction if tmp_y > @map.height - MapChip::CHIP_SIZE || tmp_y < 0
      end
  
      # プレイヤーのマップ上の座標に対するマップチップの通過可否判定
      def check_map_interaction
        # X軸方向の判定
        if @input_x >= 0
          @collision_right = check_x_direction([@map.root_x + @x + MapChip::CHIP_SIZE, @map.root_y + @y + MapChip::CHIP_SIZE / 2], 1) # 右
        else
          @collision_left = check_x_direction([@map.root_x + @x, @map.root_y + @y + MapChip::CHIP_SIZE / 2], -1) # 右
        end
  
        # y軸方向の判定
        if @dy >= 0
          p "@c_b 代入"
          @collision_bottom = check_y_direction([@map.root_x + @x + MapChip::CHIP_SIZE / 2, @map.root_y + @y + MapChip::CHIP_SIZE], 1) # 下
        else
          @collision_top = check_y_direction([@map.root_x + @x + MapChip::CHIP_SIZE / 2, @map.root_y + @y], -1) # 上
        end
      end
  
      # X軸方向の移動停止判定
      def check_x_direction(win_pos, offset)
        player_pos = @map.convert_win_to_map(win_pos)
        chip_num = @map.get_chip_num(player_pos)
        chip_weight = @map.get_chip_weight(chip_num)
        if chip_weight == Map::WALL_CHIP_WEIGHT
          player_view = @map.convert_map_to_win(player_pos)
          @debug_boxes << player_view if Director::DEBUG_MODE
          stop_x_direction
          @x = player_view[0].to_i - @map.root_x - (MapChip::CHIP_SIZE * offset)
          return true
        end
        return false
      end
  
      # Y軸方向の移動停止判定
      def check_y_direction(win_pos, offset)
        player_pos = @map.convert_win_to_map(win_pos)
        chip_num = @map.get_chip_num(player_pos)
        chip_weight = @map.get_chip_weight(chip_num)
        if chip_weight == Map::WALL_CHIP_WEIGHT
          player_view = @map.convert_map_to_win(player_pos)
          @debug_boxes << player_view if Director::DEBUG_MODE
          stop_y_direction
          @y = player_view[1].to_i - @map.root_y - (MapChip::CHIP_SIZE * offset)
          return true
        end
        return false
      end
  
      # X軸方向の移動量をクリアする
      def stop_x_direction
        @dx = 0
        @speed_x = 0
        Scene.move_to(:gameover)
      end
  
      # Y軸方向の移動量をクリアする
      def stop_y_direction
        @dy = 0
        @speed_y = 0
      end
  
      #@jump_power を減らす
      def min_jump_power
        @jump_power += 2     
        @dy += @jump_power
        #@dy += @speed
        p "@dy = #@dy / @j_p = #@jump_power"
      end
  
    end
  end