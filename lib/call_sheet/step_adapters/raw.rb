require "call_sheet/step_adapters"

module CallSheet
  class StepAdapters
    # @api private
    class Raw
      def call(step, *args, input)
        step.operation.call(*args, input)
      end
    end

    register :step, Raw.new
  end
end
