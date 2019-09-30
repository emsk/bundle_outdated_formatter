RSpec.describe BundleOutdatedFormatter::TSVFormatter do
  let(:pretty) { false }
  let(:style) { 'unicode' }
  let(:column) { %w[gem newest installed requested groups] }
  let(:formatter) { described_class.new(pretty: pretty, style: style, column: column) }

  describe '#convert' do
    subject { formatter.convert }

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

      let(:text_tsv) do
        <<-EOS.chomp
"gem"	"newest"	"installed"	"requested"	"groups"
"faker"	"1.6.6"	"1.6.5"	"~> 1.4"	"development, test"
"hashie"	"3.4.6"	"1.2.0"	"= 1.2.0"	"default"
"headless"	"2.3.1"	"2.2.3"	""	""
        EOS
      end

      before do
        formatter.instance_variable_set(:@outdated_gems, outdated_gems)
      end

      context 'when @pretty is false and @style is unicode' do
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is true and @style is unicode' do
        let(:pretty) { true }
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is false and @style is ascii' do
        let(:style) { 'ascii' }
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is true and @style is ascii' do
        let(:pretty) { true }
        let(:style) { 'ascii' }
        it { is_expected.to eq text_tsv }
      end
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

      let(:text_tsv) do
        <<-EOS.chomp
"newest"	"requested"	"gem"
"1.6.6"	"~> 1.4"	"faker"
"3.4.6"	"= 1.2.0"	"hashie"
"2.3.1"	""	"headless"
        EOS
      end

      before do
        formatter.instance_variable_set(:@outdated_gems, outdated_gems)
      end

      context 'when @pretty is false and @style is unicode' do
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is true and @style is unicode' do
        let(:pretty) { true }
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is false and @style is ascii' do
        let(:style) { 'ascii' }
        it { is_expected.to eq text_tsv }
      end

      context 'when @pretty is true and @style is ascii' do
        let(:pretty) { true }
        let(:style) { 'ascii' }
        it { is_expected.to eq text_tsv }
      end
    end
  end
end
