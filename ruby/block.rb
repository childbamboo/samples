require "prawn"

p '# create instance'
pdf = Prawn::Document.new
pdf.text 'hello world'
pdf.render_file 'hello-01.pdf'

p '# add class method at class'
class Prawn::Document
  def self.generate(file, *args, &block)
    pdf = Prawn::Document.new *args
    pdf.instance_eval &block
    pdf.render_file file
  end
end

p '## execute generate using class method'
Prawn::Document.generate('hello-02.pdf') do
  text 'hello world'
end

p '## execute generate using class method'
class MyBestFriend
  def initialize
    @first_name = 'paul'
    @last_name = 'Mouzas'
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def generate_pdf
    Prawn::Document.generate('friend-01.pdf') do |pdf|
      pdf.text "My best friend is #{full_name}"
    end
  end
end

p '## execute generate using arity'
class Prawn::Document
  def self.generate(file, *args, &block)
    pdf = Prawn::Document.new *args
    block.arity < 1 ? pdf.instance_eval(&block) : block.call(pdf)
    pdf.render_file file
  end
end

MyBestFriend.new.generate_pdf

p '# lambda'
p lambda { |x| x + 1 }.arity
p lambda { |x, y, z| x + y + z + 1 }.arity
p lambda { 1 }.arity

p '# instance_method'
p Comparable.instance_method(:between?).arity

class Object
  def double
    self + self
  end
end
 
method = Object.instance_method(:double)
p method.bind("hello").call
p method.bind(2).call
