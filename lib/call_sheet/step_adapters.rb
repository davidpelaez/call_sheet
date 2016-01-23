require "dry-container"

module CallSheet
  class StepAdapters
    extend Dry::Container::Mixin
  end
end

require "call_sheet/step_adapters/map"
require "call_sheet/step_adapters/raw"
require "call_sheet/step_adapters/tee"
require "call_sheet/step_adapters/try"
