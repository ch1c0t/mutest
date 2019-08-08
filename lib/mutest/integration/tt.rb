require 'tt'

module Mutest
  class Integration
    class Tt < self
      def all_tests
      end

      def call _tests
        project = TT::Project.new
        start = Time.now
        report = project.run

        Result::Test.new(
          output: report.to_s,
          passed: report.ok?,
          runtime: Time.now - start,
          tests: [Test.new(expression: '*', id: '0')]
        )
      end
    end
  end
end
