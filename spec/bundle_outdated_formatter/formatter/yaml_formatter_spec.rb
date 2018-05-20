RSpec.describe BundleOutdatedFormatter::YAMLFormatter do
  let(:pretty) { false }
  let(:style) { 'unicode' }
  let(:formatter) { described_class.new(pretty: pretty, style: style) }

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

  let(:text_yaml) do
    <<-EOS.chomp
---
- gem: faker
  newest: 1.6.6
  installed: 1.6.5
  requested: "~> 1.4"
  groups: development, test
- gem: hashie
  newest: 3.4.6
  installed: 1.2.0
  requested: "= 1.2.0"
  groups: default
- gem: headless
  newest: 2.3.1
  installed: 2.2.3
  requested: ''
  groups: ''
    EOS
  end

  describe '#convert' do
    before do
      formatter.instance_variable_set(:@outdated_gems, outdated_gems)
    end

    subject { formatter.convert }

    context 'when @pretty is false and @style is unicode' do
      it { is_expected.to eq text_yaml }
    end

    context 'when @pretty is true and @style is unicode' do
      let(:pretty) { true }
      it { is_expected.to eq text_yaml }
    end

    context 'when @pretty is false and @style is ascii' do
      let(:style) { 'ascii' }
      it { is_expected.to eq text_yaml }
    end

    context 'when @pretty is true and @style is ascii' do
      let(:pretty) { true }
      let(:style) { 'ascii' }
      it { is_expected.to eq text_yaml }
    end
  end
end
