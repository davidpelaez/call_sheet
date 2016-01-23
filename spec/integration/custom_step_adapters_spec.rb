RSpec.describe "Custom step adapters" do
  let(:call_sheet) {
    CallSheet(container: container, step_adapters: Test::CustomStepAdapters) do
      map :process
      tee :persist
      enqueue :deliver
    end
  }

  let(:container) {
    {
      process: -> input { {name: input["name"], email: input["email"]} },
      persist: -> input { Test::DB << input and true },
      deliver: -> input { "Delivered email to #{input[:email]}" },
    }
  }

  before do
    Test::DB = []
    Test::QUEUE = []

    module Test
      class CustomStepAdapters < CallSheet::StepAdapters
        register :enqueue do
          -> step, *args, input {
            Test::QUEUE << step.operation.call(*args, input)
            Right(input)
          }
        end
      end
    end
  end

  it "supports custom step adapters" do
    input = {"name" => "Jane", "email" => "jane@doe.com"}
    call_sheet.call(input)
    expect(Test::QUEUE).to include("Delivered email to jane@doe.com")
  end
end
