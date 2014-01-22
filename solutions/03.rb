module Graphics
  class Canvas
  attr_reader :height , :width
    def initialize(x,y)
      @layout ={}
      @height  , @width = y , x
      self
    end

    def set_pixel(x,y)
      @layout[[x,y]] = true
      self
    end

    def pixel_at?(x,y)
      @layout[[x,y]]
     end

    def draw(figure)
      figure.layout.each do |possition,value|

       set_pixel(possition[0],possition[1]) if value
      end
      self
    end

    def render_as(renderer)
      renderer.render self
    end
  end

  class Point
    attr_reader :x , :y ,:layout

    def initialize(x,y)
      @layout ={}
      @layout[[x,y]] = true
      @x , @y = x , y
    end

    def eql?(point)
      @x == point.x and @y == point.y
    end

    alias == eql?
  end


#=== Този алгоритъм е взет от Митъо и е леко преправен така че да пасва на моят canvas

    class BresenhamRasterization
      def initialize(from_x, from_y, to_x, to_y)
        @from_x, @from_y = from_x, from_y
        @to_x, @to_y     = to_x, to_y
        @layout ={}
      end

      def rasterize_on(canvas="")
        initialize_from_and_to_coordinates
        rotate_coordinates_by_ninety_degrees if steep_slope?
        swap_from_and_to if @drawing_from_x > @drawing_to_x

        draw_line_pixels_on canvas
        @layout
      end

      def steep_slope?
        (@to_y - @from_y).abs > (@to_x - @from_x).abs
      end

      def initialize_from_and_to_coordinates
        @drawing_from_x, @drawing_from_y = @from_x, @from_y
        @drawing_to_x, @drawing_to_y     = @to_x, @to_y
      end

      def rotate_coordinates_by_ninety_degrees
        @drawing_from_x, @drawing_from_y = @drawing_from_y, @drawing_from_x
        @drawing_to_x, @drawing_to_y     = @drawing_to_y, @drawing_to_x
      end

      def swap_from_and_to
        @drawing_from_x, @drawing_to_x = @drawing_to_x, @drawing_from_x
        @drawing_from_y, @drawing_to_y = @drawing_to_y, @drawing_from_y
      end

      def error_delta
        delta_x = @drawing_to_x - @drawing_from_x
        delta_y = (@drawing_to_y - @drawing_from_y).abs

        delta_y.to_f / delta_x
      end

      def vertical_drawing_direction
        @drawing_from_y < @drawing_to_y ? 1 : -1
      end

      def draw_line_pixels_on(canvas)
        @error = 0.0
        @y     = @drawing_from_y

        @drawing_from_x.upto(@drawing_to_x).each do |x|
          @layout[[x,@y]] = true
          calculate_next_y_approximation
        end
      end

      def calculate_next_y_approximation
        @error += error_delta

        if @error >= 0.5
          @error -= 1.0
          @y += vertical_drawing_direction
        end
      end

      def set_pixel_on(canvas, x, y)
        if steep_slope?
          @layout[[x,y]] = true
        else
          @layout[[y,x]] = true
        end
      end
    end

#===

  class Line
    attr_reader :from , :to ,:layout

    def initialize(start_point,end_point)
      @layout ={}

      if start_point.x > end_point.x or ( start_point.y > end_point.y)
        @from = end_point
        @to   = start_point
      else
        @from = start_point
        @to   = end_point
      end


      if(start_point.x ==end_point.x or start_point.y == end_point.y)
        straight_line( @from,@to)
      else
        @layout =BresenhamRasterization.new( @from.x,  @from.y, @to.x, @to.y).rasterize_on

      end
    end


    def straight_line(start_point,end_point)
        (start_point.x).upto(end_point.x) { |i|  @layout[[i,start_point.y]] =@layout[[i, end_point.y] ] = true   }
        (start_point.y).upto(end_point.y) do |i|
          @layout[[start_point.x, i]] = true
          @layout[[end_point.x, i]] = true
        end
        @to = end_point

    end

    def eql?(line)
      @from== line.from and @to == line.to
    end

    alias == eql?

  end


  class Rectangle
    attr_reader :top_left , :top_right , :bottom_left , :bottom_right ,:layout
    def min(x,y)
      return x if x<y
      y
    end

    def max(x,y)
      return y if x<y
      x
    end

    def initialize(start_point,end_point)
        @layout ={}


      @bottom_right =Point.new( max(start_point.x , end_point.x), max(start_point.y,end_point.y) )
      @bottom_left =Point.new( min(start_point.x , end_point.x), max(start_point.y,end_point.y) )
      @top_left =Point.new( min(start_point.x , end_point.x), min(start_point.y,end_point.y) )
      @top_right =Point.new( max(start_point.x , end_point.x), min(start_point.y,end_point.y) )


      draw_it(@top_left,@bottom_right)
    end

    def draw_it(start_point,end_point)
      (start_point.x).upto(end_point.x) { |i| @layout[[i,start_point.y]] = @layout[[i, end_point.y]] = true   }
      (start_point.y).upto(end_point.y) do |i|
        @layout[[start_point.x,i]] = true
        @layout[[end_point.x,i]] = true
      end
    end

    def eql?(rectangle)
      @top_left == rectangle.top_left and @bottom_right == rectangle.bottom_right
    end

    alias == eql?

  end


  module Renderers

    module Ascii

      def self.render(canvas)
        output = ""
        0.upto(canvas.height-1) do|i|
          0.upto(canvas.width-1) do |j|
            pixel =  canvas.pixel_at?(j,i) ? "@" :  "-"
            output << pixel
          end
           output << "\n" unless i == canvas.height-1
        end
        output
      end
     end

    module Html
       RENDER = {footer: " </div>
                </body>
                </html>" , header: '  <!DOCTYPE html>
                <html>
                <head>
                  <title>Rendered Canvas</title>
                  <style type="text/css">
                    .canvas {
                font-size: 1px;
                line-height: 1px;
                    }
                    .canvas * {
                display: inline-block;
                width: 10px;
                height: 10px;
                border-radius: 5px;
                    }
                    .canvas i {
                background-color: #eee;
                    }
                    .canvas b {
                background-color: #333;
                    }
                  </style>
                </head>
                <body>
                  <div class="canvas">'
                }

    def self.render(canvas)
        output = RENDER[:header]
        0.upto(canvas.height-1) do|i|
          0.upto(canvas.width-1) do |j|
            pixel =  canvas.pixel_at?(j,i) ? "<b></b>" : "<i></i>"
            output << pixel

          end
          output << "<br>" unless i == canvas.height-1
        end
        output<<RENDER[:footer]

      end

    end
  end

end