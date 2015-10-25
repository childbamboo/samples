klass_object = nil

p '# names class'
ThirdClass = Class.new do |klass|
  klass_object = klass
  p klass == self

  def hello
    :hello
  end
end

p klass_object == ThirdClass

third_class_instance = ThirdClass.new
p third_class_instance.hello
p ThirdClass.name

p '-----------------------------'
p '# no names class'
klass = Class.new
p klass.name

obj = klass.new
p obj.class
NamedClass = klass
p klass.name

p '-----------------------------'
p '# class scope'
externam_scope = 1

class ExpDefineClass
  begin
    p externam_scope
  rescue => e
    p e
  end
end

NewDefineClass = Class.new do
  p externam_scope
end

p '-----------------------------'
p '# class definition'
class Klass
  p self
  @class_instance_val = :class_instance_val
  @@class_val = :class_val

  def self.class_instance_val
    p @class_instance_val
  end

  def instance_method
    p @class_instance_val
    p @@class_val
  end
end

p '## class instance value'
Klass.class_instance_val

p '## class instance value2'
Klass.new.instance_method

p '-----------------------------'
p '# class definition'
class Klass
  @class_instance_val = :class_instance_val

  def instance_method
    p @class_instance_val
    p self.class.instance_variable_get :@class_instance_val
  end
end

p '## class instance value2'
Klass.new.instance_method

p '-----------------------------'
p '# class inheritclass'
class Klass
  @class_instance_val = :class_instance_val
  @@class_val = :class_val
end

class InheritKlass < Klass
  p @class_instance_val
  p @@class_val
end

p '-----------------------------'
p '# instance count class'
class InstanceCountClass
  @@instance_count = 0
  def self.instance_count
    @@instance_count
  end
  def initialize
    @@instance_count += 1
  end
end

p InstanceCountClass.instance_count

5.times do
  InstanceCountClass.new
end

p InstanceCountClass.instance_count

p '-----------------------------'
p '# class method'
class Klass
  def self.class_method
    :class_method
  end
end

class Klass
  def (p self).class_method
    :class_method
  end
end

class Klass
  def Klass.class_method
    :class_method
  end
end

class Klass
end

def Klass.class_method
  :class_method
end

p Klass.class_method

p '-----------------------------'
p '# instance method'
class Klass
  def instance_method
    :instance_method
  end 
end

class Klass
  define_method :instance_method, -> { :instance_method }
end

object = Klass.new
p object.instance_method

module IncludeModule
  def included_module_method
    :included_module_method
  end
end

class Klass
  include IncludeModule

  define_method :included_module_method, 
    IncludeModule.instance_method(:included_module_method)
end

object = Klass.new
p object.included_module_method

module UnIncludedModule
  def un_included_module_method
    :un_included_module_method
  end
end

class Klass
  define_method :un_included_module_method, UnIncludedModule.instance_method(:un_included_module_method)
end

module FirstIncludeModule
  def same_name_method
    :first_included_module
  end
end

module SecondIncludeModule
  def same_name_method
    :second_included_module
  end
end

class Klass
  include FirstIncludeModule
  include SecondIncludeModule
end

object = Klass.new
p object.same_name_method
