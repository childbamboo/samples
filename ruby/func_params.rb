p '# gets params by hash'
def func1(options={})
  p "#{options[:p1]} is #{options[:p2]}"
end

p '## puts hash varuables.'
options = {p1: 'hoge1', p2: 'hoge2'}
func1 options

p '## puts hash varuables directry'
func1 p1: 'hoge1', p2: 'hoge2'

p ''
p '# gets params by a varuable and hash'
def func2(param1, options={})
  p "#{param1}, #{options[:p1]} and #{options[:p2]}"
end

p '## puts string and hash varuables.'
options = {p1: 'hoge1', p2: 'hoge2'}
func2 'bar1', options

p '## puts string and hash varuables directry'
func2 'bar1', p1: 'hoge1', p2: 'hoge2'

p ''
p '# gets params by hash and merge default varuables'
def func3(options={})
  options = {p1: 'hoge1-def', p2: 'hoge2-def'}.merge(options)
  p "#{options[:p1]} is #{options[:p2]}"
end

p '## puts hash varuables.'
func3
func3 p1: 'hoge1'
func3 p1: 'hoge1', p2: 'hoge2'

p '# gets specific params.'
def func4(x1, y1, x2, y2)
  p "hypot: #{Math.hypot(x2 - x1, y2 - y1)}"
end

p '## puts specific varuables.'
func4 1, 1, 3, 5

p '# gets array params.'
def func5(*points)
  p *points
  func4 *points.flatten
end

p '## puts arraies.'
func5 [3,3], [4,5] 
func5 [3], [3,4,5] 
