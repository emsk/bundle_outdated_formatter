RSpec.describe BundleOutdatedFormatter::Formatter do
  let(:pretty) { false }
  let(:formatter) { described_class.new(pretty: pretty) }

  let(:stdin) do
    <<-EOS
Fetching gem metadata from https://rubygems.org/..........
Fetching version metadata from https://rubygems.org/...
Fetching dependency metadata from https://rubygems.org/..
Resolving dependencies...

Outdated gems included in the bundle:
* faker (newest 1.6.6, installed 1.6.5, requested ~> 1.4) in groups "development, test"
* hashie (newest 3.4.6, installed 1.2.0, requested = 1.2.0) in groups "default"
* headless (newest 2.3.1, installed 2.2.3)
    EOS
  end

  let(:outdated_gems) do
    [
      {
        'gem'       => 'faker',
        'newest'    => '1.6.6',
        'installed' => '1.6.5',
        'requested' => '~> 1.4',
        'groups'    => 'development, test'
      },
      {
        'gem'       => 'hashie',
        'newest'    => '3.4.6',
        'installed' => '1.2.0',
        'requested' => '= 1.2.0',
        'groups'    => 'default'
      },
      {
        'gem'       => 'headless',
        'newest'    => '2.3.1',
        'installed' => '2.2.3',
        'requested' => '',
        'groups'    => ''
      }
    ]
  end

  describe '.new' do
    describe '@outdated_gems' do
      subject { formatter.instance_variable_get(:@outdated_gems) }
      it { is_expected.to eq [] }
    end
  end

  describe '#read_stdin' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
      formatter.read_stdin
    end

    describe '@outdated_gems' do
      subject { formatter.instance_variable_get(:@outdated_gems) }
      it { is_expected.to eq outdated_gems }
    end
  end
end
