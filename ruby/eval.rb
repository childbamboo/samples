p '# eval variables.'
a = 10
eval 'a = 1'
p a

eval 'p self'

p '# eval family'
object = Object.new
object.instance_eval { p self }
object.class.class_eval { p self }
Kernel.module_eval { p self }

p '# eval logging instance variable'
class LoggingInstanceVariable
  attr_reader :first_val, :before_first_val

  def first_val=(val)
    @before_first_val = @first_val
    @first_val = val
  end
end

obj = LoggingInstanceVariable.new
obj.first_val = 1
p obj.first_val
p obj.before_first_val

obj.first_val = 2
p obj.first_val
p obj.before_first_val

p '# eval logging instance variable'
class LoggingInstanceVariable
  logging_instance_val_name = %w(first_val second_val third_val)

  logging_instance_val_name.each do |val_name|
    eval <<-END_OF_DEF
      attr_reader :#{val_name}, :before_#{val_name}

      def #{val_name}=(val)
        @before_#{val_name} = @#{val_name}
        @#{val_name} = val
      end
    END_OF_DEF
  end
end

obj = LoggingInstanceVariable.new
obj.first_val = 1
obj.first_val = 2
p obj.first_val
p obj.before_first_val

obj.third_val = :third_val
obj.third_val = 'third_val'
p obj.third_val
p obj.before_third_val

p '# attr class'
class AttrClass
  def initialize
    @attr = 'attr'
  end

  def add_reader(instance_val_name)
    eval <<-END_OF_DEF
      def #{instance_val_name}
        @#{instance_val_name}
      end
    END_OF_DEF
  end

  def add_writer(instance_val_name)
    eval <<-END_OF_DEF
      def #{instance_val_name}=(val)
        @#{instance_val_name} = val
      end
    END_OF_DEF
  end
end

p attr_obj = AttrClass.new
p attr_obj.respond_to? :attr

attr_obj.add_reader 'attr'
p attr_obj.respond_to? 'attr'
p attr_obj.attr

p attr_obj.respond_to? :attr=
attr_obj.add_writer 'attr'
p attr_obj.respond_to? 'attr='

attr_obj.attr = 'new val'
p attr_obj.attr
