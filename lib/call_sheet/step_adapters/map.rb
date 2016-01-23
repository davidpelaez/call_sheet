require "call_sheet/step_adapters"

module CallSheet
  class StepAdapters
    # @api private
    class Map
      def call(step, *args, input)
        Right(step.operation.call(*args, input))
      end
    end

    register :map, Map.new
  end
end
