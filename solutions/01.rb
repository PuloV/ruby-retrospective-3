class Integer
        def prime()
                return false if self < 0
                return true if self < 3
                (2.. Math.sqrt(self.abs)).each do |var|
                        if self%var == 0
                                 return  false
                         end
                end
                return true
        end
        def prime_factors()
                primes = []
                return self if self.prime
                (2 .. self).each do |d|
                  if self % d == 0 and d.prime
                        primes.push(d)
                        return primes.push((self/d ) . prime_factors)
                  end
                end
        end
        def harmonic()
                if self < 0
                        return false
                end
                 harmNum = Rational(1,1)
                (2.. self).each do |var|
                        harmNum += Rational(1,var)
                end
                return harmNum
        end
        def digits()
                currNum = self
                digitsArray = []
                while currNum != 0
                        digitsArray.push(currNum % 10)
                        currNum /= 10
                end
                return digitsArray.reverse
        end
end
class Array
        def average()
                totalValue = 0.0
                (0... self.size).each do |var|
                        totalValue+=self[var]
                end
                return totalValue/self.size
        end
        def frequencies()
                frequenciesArray = Hash.new
                (0... self.size).each do |var|
                        if frequenciesArray[self[var]] == nil
                                frequenciesArray[self[var]] = 0
                        end
                                frequenciesArray[self[var]] += 1
                end
                return frequenciesArray
        end
        def drop_every(n)
                dropped = []
                (0... self.size).each do |var|
                        if (var+1)%n  != 0
                         dropped.push(self[var])
                        end
                end
                return dropped
        end
        def combine_with(other)
                max  = self.size > other.size ? self.size : other.size
                combination = []
                (0...max).each do |i|
                        combination.push(self[i]) if self[i]
                        combination.push(other[i]) if other[i]
                end
                return combination
        end
end