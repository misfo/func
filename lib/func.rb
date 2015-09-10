require 'func/call_instance'
require 'func/callable'
require 'func/init_ivars'
require 'func/version'

class Func
  extend CallInstance
  include InitIvars
  include Callable

  def call
    raise NotImplementedError, 'Func must be subclassed with a no-arg `call` method'
  end
end
