class Integer

  def prime?()
    return false if self <= 1
    return true if self <= 3
    2.upto(Math.sqrt(self.abs)).each do |var|
      if self%var == 0
         return  false
       end
    end
    return true
  end

  def prime_factors()
    primes = []
    return [self.abs] if self.prime?
    2.upto(self.abs) do |i|
      if self % i == 0 and i.prime?
      primes.push(i)
      return (self/i) . prime_factors.insert(0,i)
      end
    end
  end

  def harmonic()
    if self < 0
      return false
    end
     harmNum = Rational(1,1)
     2.upto(self) do |var|
      harmNum += Rational(1,var)
    end
    harmNum
  end

  def digits()
    currNum = self.abs
    return [0] if self == 0
    digitsArray = []
    while currNum != 0
      digitsArray.push(currNum % 10)
      currNum /= 10
    end
    digitsArray.reverse
  end

end

class Array

  def average()
    totalValue = self.reduce(:+)
    totalValue/self.size
  end

  def frequencies()
    frequenciesArray = Hash.new
    0.upto(self.size).each do |var|
      if !frequenciesArray[self[var]]
        frequenciesArray[self[var]] = 0
      end
        frequenciesArray[self[var]] += 1
    end
    frequenciesArray
  end

  def drop_every(n)
    dropped = []
    0.upto(self.size).each do |var|
      if (var+1)%n  != 0
       dropped.push(self[var])
      end
    end
    dropped
  end

  def combine_with(other)
    max  = self.size > other.size ? self.size : other.size
    return self if other.size == 0
    return other if self.size == 0
    combination = []
    0.upto(max) do |i|
      combination.push(self[i]) if i < self.size
      combination.push(other[i]) if i < other.size
    end
    combination
  end

end