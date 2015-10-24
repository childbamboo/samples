
p '# case string'
def func1(string)
  case string
  when /good morning/
   puts 'good morninig. how are you?'
  when /good afternoon/
   puts 'good afternoon. how is wheather?'
  when /good evening/
   puts 'good evening. great job!'
  else
   puts 'what is happened'
end
end

func1 "good morning hogehoge"
func1 "hogehoge"

p ''
p '# case object'
def func2(obj)
  case obj
  when Array
    puts 'Array'
  when Hash
    puts 'Hash'
  when String, Symbol
    puts 'String or Symbol'
  when Numeric
    puts 'Numeric'
  else
   puts 'I do not know'
  end
end

func2 [1]
func2 hoge: 'hoge'
func2 :hoge

p ''
p '# case time'
def func4
  case Time.now.hour
  when (6..8)
    puts '6..8'
  when (9..11)
    puts '9..11'
  when (12..13)
    puts '12..13'
  when (14..16)
    puts '14..16'
  when (17..18)
    puts '17..18'
  when (19..20)
    puts '19..20'
  when (21..23)
    puts '21..23'
  when (0..5)
    puts '0..5'
  end
end

func4
