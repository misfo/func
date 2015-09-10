require 'func/call_instance'
require 'func/init_ivars'
require 'func/version'

class Func
  extend CallInstance
  include InitIvars

  def call
    raise NotImplementedError, 'Func must be subclassed with a no-arg `call` method'
  end
end
