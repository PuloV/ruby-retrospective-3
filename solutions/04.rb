#jump-овете  само за label-и които вече са срещани
module Asm

  class Inline_assembler
    attr :ax , :bx , :cx , :dx
    attr_reader :registers

    def initialize()
      @queue = {}
      @registers={:ax=>{:value=>0},:bx=>{:value=>0},:cx =>{:value=>0},:dx=>{:value=>0}}
      @ax = @registers[:ax]
      @bx = @registers[:bx]
      @cx = @registers[:cx]
      @dx = @registers[:dx]
      @last_cmp = 0
      @Func = Struct.new(:name, :args)
    end

    conditional_jumps = {
      je:         :'==',
      jne:        :'!=',
      jl:         :'<',
      jle:        :'<=',
      jg:         :'>',
      jge:        :'>=',

    }

    conditional_jumps.each do |method_name, operation|
      define_method method_name do |argument,*args|

        jmp(argument,*args) if @last_cmp.send(operation,0)
      end
    end

    def mov(x,y)
      @queue.each {|_,j|  j << @Func.new("mov", [x,y]) }
      ( y.is_a? Numeric )? x[:value] = y : x[:value] =  y[:value]
      self
    end

    def inc(x,y=1)
      @queue.each {|_,j|  j << @Func.new("inc", [x,y]) }
      ( y.is_a? Numeric )? x[:value] += y : x[:value] +=  y[:value]
      self
    end

    def dec(x,y=1)
      @queue.each {|_,j|  j << @Func.new("dec", [x,y]) }
      ( y.is_a? Numeric )? x[:value] -= y : x[:value] -=  y[:value]
      self
    end

    def cmp (x,y)
      @queue.each {|_,j|  j << @Func.new("cmp", [x,y]) }
      @last_cmp =  ( y.is_a? Numeric )? x[:value] <=> y : x[:value] <=>  y[:value]
      self
    end

    def label (label_name)
      @queue[label_name] = []
    end

    def jmp(where,*args)
      n = @queue[where].size - 1
      0.upto(n) do |j|
        element = @queue[where][j]
        send(element.name,element.args[0],element.args[1])
      end
    end

    def method_missing(name , *args)
      name
    end

  end

  def self.asm(&block)
    asm =Inline_assembler.new
    asm.instance_eval(&block)
     asm.registers.map { |_,e| e[:value]  }
  end

end