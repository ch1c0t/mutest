require 'spec_helper'

describe Mutant::Matcher::Namespace do
  let(:object) { described_class.new(cache, Mutant::Expression.parse('TestApp*')) }
  let(:yields) { []                                             }

  let(:cache) { Mutant::Cache.new }

  subject { object.each { |item| yields << item } }

  describe '#each' do

    let(:singleton_a) { double('SingletonA', name: 'TestApp::Literal') }
    let(:singleton_b) { double('SingletonB', name: 'TestApp::Foo')     }
    let(:singleton_c) { double('SingletonC', name: 'TestAppOther')     }
    let(:subject_a)   { double('SubjectA')                             }
    let(:subject_b)   { double('SubjectB')                             }

    before do
      allow(Mutant::Matcher::Methods::Singleton).to receive(:new).with(cache, singleton_a).and_return([subject_a])
      allow(Mutant::Matcher::Methods::Instance).to receive(:new).with(cache, singleton_a).and_return([])

      allow(Mutant::Matcher::Methods::Singleton).to receive(:new).with(cache, singleton_b).and_return([subject_b])
      allow(Mutant::Matcher::Methods::Instance).to receive(:new).with(cache, singleton_b).and_return([])

      allow(ObjectSpace).to receive(:each_object).with(Module).and_return([singleton_a, singleton_b, singleton_c])
    end

    context 'with no block' do
      subject { object.each }

      it { should be_instance_of(to_enum.class) }

      it 'yields the expected values' do
        expect(subject.to_a).to eql(object.to_a)
      end
    end

    it 'should yield subjects' do
      expect { subject }.to change { yields }.from([]).to([subject_b, subject_a])
    end
  end
end
