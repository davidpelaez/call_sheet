require "call_sheet/step"
require "call_sheet/step_adapters"
require "call_sheet/transaction"

module CallSheet
  # @api private
  class DSL
    attr_reader :container
    attr_reader :step_adapters
    attr_reader :steps

    def initialize(options, &block)
      @container = options.fetch(:container)
      @step_adapters = options.fetch(:step_adapters, StepAdapters)
      @steps = []

      instance_eval(&block)
    end

    def respond_to_missing?(method_name)
      step_adapters.key?(method_name)
    end

    def method_missing(method_name, *args)
      return super unless step_adapters.key?(method_name)

      step_adapter = step_adapters[method_name]
      step_name = args.first
      options = args.last.is_a?(Hash) ? args.last : {}
      operation_name = options.delete(:with) || step_name
      operation = container[operation_name]

      steps << Step.new(step_adapter, step_name, operation_name, operation, options)
    end

    # @api private
    def call
      Transaction.new(steps)
    end
  end
end
