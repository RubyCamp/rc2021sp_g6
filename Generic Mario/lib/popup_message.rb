class PopupMessage < Component
  FONT_SIZE = 28

  attr_accessor :life

  def initialize(message, x = nil, y = nil)
    @font = Font.new(FONT_SIZE)
    @x, @y, @message = x, y, message
    message_width = @font.get_width(@message)
    w_mergin = 20
    h_mergin = 15
    @image = Image.new(message_width + (w_mergin * 2), FONT_SIZE + (h_mergin * 2), C_WHITE)
    @image.draw_font(w_mergin, h_mergin, @message, @font, C_BLACK)
    @x ||= Window.width / 2 - @image.width / 2
    @y ||= Window.height / 2 - @image.height / 2
    self.life = 0

    super(@x, @y, @image.width, @image.height)
  end

  # 1フレーム分の描画処理
  def draw
    return if self.life <= 0
    Window.draw(@x, @y, @image)
    self.life -= 1
  end
end