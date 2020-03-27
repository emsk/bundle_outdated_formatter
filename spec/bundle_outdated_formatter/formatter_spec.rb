RSpec.describe BundleOutdatedFormatter::Formatter do
  let(:pretty) { false }
  let(:column) { %w[gem newest installed requested groups] }
  let(:formatter) { described_class.new(pretty: pretty, column: column) }

  let(:stdin) do
    <<-EOS
Warning: the running version of Bundler (1.16.1) is older than the version that created the lockfile (1.16.2). We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.
Fetching gem metadata from https://rubygems.org/..........
Fetching version metadata from https://rubygems.org/...
Fetching dependency metadata from https://rubygems.org/..
Resolving dependencies...

Outdated gems included in the bundle:
  * faker (newest 1.6.6, installed 1.6.5, requested ~> 1.4) in groups "development, test"
  * hashie (newest 3.4.6, installed 1.2.0, requested = 1.2.0) in group "default"
  * headless (newest 2.3.1, installed 2.2.3)
    EOS
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

      context "when @column is ['gem', 'newest', 'installed', 'requested', 'groups']" do
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

        it { is_expected.to eq outdated_gems }
      end

      context "when @column is ['newest', 'requested', 'gem']" do
        let(:column) { %w[newest requested gem] }
        let(:outdated_gems) do
          [
            {
              'newest'    => '1.6.6',
              'requested' => '~> 1.4',
              'gem'       => 'faker'
            },
            {
              'newest'    => '3.4.6',
              'requested' => '= 1.2.0',
              'gem'       => 'hashie'
            },
            {
              'newest'    => '2.3.1',
              'requested' => '',
              'gem'       => 'headless'
            }
          ]
        end

        it { is_expected.to eq outdated_gems }
      end
    end
  end
end
