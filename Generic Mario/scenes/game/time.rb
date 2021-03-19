

class Countdown
	#attr_accessor :min
	#attr_accessor :sec

	def initialize	
		@font = Font.new(32)
		@limit_time =  30 
		@start_time = Time.now
	end
	
	def time		
		@now_time = Time.now
		@diff_time = @now_time - @start_time
		@countdown = (@limit_time - @diff_time).to_i
		$min = @countdown / 60
		$sec = @countdown % 60
		Window.drawFont(100, 100, "#{$min}:#{$sec}", @font)		
	end	

end