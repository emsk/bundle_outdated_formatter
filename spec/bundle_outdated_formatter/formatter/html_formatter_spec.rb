RSpec.describe BundleOutdatedFormatter::HTMLFormatter do
  let(:pretty) { false }
  let(:formatter) { described_class.new(pretty: pretty) }

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

  let(:text_html) do
    <<-EOS.chomp
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr><tr><td>faker</td><td>1.6.6</td><td>1.6.5</td><td>~> 1.4</td><td>development, test</td></tr><tr><td>hashie</td><td>3.4.6</td><td>1.2.0</td><td>= 1.2.0</td><td>default</td></tr><tr><td>headless</td><td>2.3.1</td><td>2.2.3</td><td></td><td></td></tr></table>
    EOS
  end

  let(:text_html_pretty) do
    <<-EOS.chomp
<table>
  <tr>
    <th>gem</th>
    <th>newest</th>
    <th>installed</th>
    <th>requested</th>
    <th>groups</th>
  </tr>
  <tr>
    <td>faker</td>
    <td>1.6.6</td>
    <td>1.6.5</td>
    <td>~> 1.4</td>
    <td>development, test</td>
  </tr>
  <tr>
    <td>hashie</td>
    <td>3.4.6</td>
    <td>1.2.0</td>
    <td>= 1.2.0</td>
    <td>default</td>
  </tr>
  <tr>
    <td>headless</td>
    <td>2.3.1</td>
    <td>2.2.3</td>
    <td></td>
    <td></td>
  </tr>
</table>
    EOS
  end

  describe '#convert' do
    before do
      formatter.instance_variable_set(:@outdated_gems, outdated_gems)
    end

    subject { formatter.convert }

    context 'when @pretty is false' do
      it { is_expected.to eq text_html }
    end

    context 'when @pretty is true' do
      let(:pretty) { true }
      it { is_expected.to eq text_html_pretty }
    end
  end
end
