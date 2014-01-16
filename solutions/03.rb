require 'matrix.rb'
        class Matrix
                def []= (i,j,x)
                        @rows[i][j] = x
                end
        end
module Graphics
        class Canvas
        attr_reader :height , :width
                def initialize(x,y)

                  @layout = Matrix.build(x, y) {false}

                  @height  , @width = x , y
                end
                def set_pixel(x,y)
                        @layout[x,y] = true
                        self
                end
                def pixel_at?(x,y)
                        @layout[x,y]
                end
                def draw(figure)
                        figure.layout.each_with_index do |col,row|
                                draw_inner_loop(col,row) if (col)
                        end
                        self
                end
                def draw_inner_loop(col,row)
                        col.each { |value| set_pixel(value,row) if value }
                end
                def render_as(renderer)
                        output = renderer::RENDER[:header]
                        @layout.each_with_index do|val , _ , coll|
                                pixel =  val ? renderer::RENDER[:render][1]  :  renderer::RENDER[:render][0]
                                output << pixel
                                 output << renderer::RENDER[:newline] if coll == width-1
                        end
                        output<<renderer::RENDER[:footer]
                end
        end

        class Point
                attr_reader :x , :y ,:layout
                def initialize(x,y)
                        @layout =[]
                        @layout[x]=[y]
                        @x , @y = x , y
                end
        end


        class Line
                attr_reader :from , :to ,:layout
                def initialize(start_point,end_point)
                        @layout =[]
                        @from = start_point
                        (start_point.x).upto(end_point.x) { |i| @layout[i] = [] }
                        if(start_point.x ==end_point.x or start_point.y == end_point.y)
                                then
                                straight_line(start_point,end_point)
                        else
                                bresenham(start_point,end_point)
                        end
                end
                def bresenham(start_point,end_point)
                  @horizontal_length=end_point.x-start_point.x
                  @vertical_length=end_point.y-start_point.y
                  @equation = 2*@vertical_length -@horizontal_length
                  @layout[start_point.x] = [start_point.y]
                  @end_point_changing=end_point.y
                  bresenham_line_loop(start_point,end_point)
                 end
                 def bresenham_line_loop(start_point,end_point)
                          (start_point.x+1).upto(end_point.x) do |i|
                    if @equation > 0
                            then
                      bresenham_equation_greater(i)
                    else
                      bresenham_equation_lower(i)
                    end
                    @to = Point.new i , @end_point_changing
                  end
                end
                def bresenham_equation_greater(i)
                        @end_point_changing = @end_point_changing+1
                  @layout[i].push(@end_point_changing)
                  @equation = @equation + (2*@vertical_length-2*@horizontal_length)
                end
                def bresenham_equation_lower(i)
                         @layout[i].push(@end_point_changing)
                   @equation =@equation + (2*@vertical_length)
                end
                def straight_line(start_point,end_point)
                          (start_point.x).upto(end_point.x) { |i| @layout[i] =[start_point.y , end_point.y]                }
                                                (start_point.y).upto(end_point.y) do |i|
                                @layout[start_point.x] .push(i)
                                @layout[end_point.x] .push(i)
                  end
                  @to = end_point
                end
        end


        class Rectangle
                attr_reader :top_left , :top_right , :bottom_left , :bottom_right ,:layout
                def initialize(start_point,end_point)
                        @layout =[]
                        @top_left , @top_right = start_point , Point.new(start_point.x,end_point.y)
                        @bottom_left = Point.new(end_point.x,start_point.y)
                        @bottom_right = end_point
                        draw_it(start_point,end_point)
                end
                def draw_it(start_point,end_point)
                        (start_point.x).upto(end_point.x) { |i| @layout[i] =[start_point.y , end_point.y]                }
                        (start_point.y).upto(end_point.y) do |i|
                                @layout[start_point.x] .push(i)
                                @layout[end_point.x] .push(i)
                        end
                end
        end


        module Renderers
                module Ascii
                        RENDER = {footer: "" , header: "" , render: ["-" ,"@"] , newline: "\n"}
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
    <div class="canvas">' , render: ["<i></i>" ,"<b></b>"] , newline: "<br/> \n"}
          end
        end

end