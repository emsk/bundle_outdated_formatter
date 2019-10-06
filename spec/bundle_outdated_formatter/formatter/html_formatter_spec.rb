RSpec.describe BundleOutdatedFormatter::HTMLFormatter do
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
          },
          {
            'gem'       => 'rbnacl',
            'newest'    => '5.0.0',
            'installed' => '4.0.2',
            'requested' => '>= 3.2, < 5.0',
            'groups'    => ''
          }
        ]
      end

      let(:text_html) do
        <<-EOS.chomp
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr><tr><td>faker</td><td>1.6.6</td><td>1.6.5</td><td>~&gt; 1.4</td><td>development, test</td></tr><tr><td>hashie</td><td>3.4.6</td><td>1.2.0</td><td>= 1.2.0</td><td>default</td></tr><tr><td>headless</td><td>2.3.1</td><td>2.2.3</td><td></td><td></td></tr><tr><td>rbnacl</td><td>5.0.0</td><td>4.0.2</td><td>&gt;= 3.2, &lt; 5.0</td><td></td></tr></table>
        EOS
      end

      let(:text_html_without_outdated) do
        <<-EOS.chomp
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr></table>
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
    <td>~&gt; 1.4</td>
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
  <tr>
    <td>rbnacl</td>
    <td>5.0.0</td>
    <td>4.0.2</td>
    <td>&gt;= 3.2, &lt; 5.0</td>
    <td></td>
  </tr>
</table>
        EOS
      end

      let(:text_html_pretty_without_outdated) do
        <<-EOS.chomp
<table>
  <tr>
    <th>gem</th>
    <th>newest</th>
    <th>installed</th>
    <th>requested</th>
    <th>groups</th>
  </tr>
</table>
        EOS
      end

      before do
        formatter.instance_variable_set(:@outdated_gems, outdated_gems)
      end

      context 'when @pretty is false and @style is unicode' do
        it { is_expected.to eq text_html }

        context 'without outdated' do
          let(:outdated_gems) { [] }

          it { is_expected.to eq text_html_without_outdated }
        end
      end

      context 'when @pretty is true and @style is unicode' do
        let(:pretty) { true }

        it { is_expected.to eq text_html_pretty }

        context 'without outdated' do
          let(:outdated_gems) { [] }

          it { is_expected.to eq text_html_pretty_without_outdated }
        end
      end

      context 'when @pretty is false and @style is ascii' do
        let(:style) { 'ascii' }

        it { is_expected.to eq text_html }
      end

      context 'when @pretty is true and @style is ascii' do
        let(:pretty) { true }
        let(:style) { 'ascii' }

        it { is_expected.to eq text_html_pretty }
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
          },
          {
            'newest'    => '5.0.0',
            'requested' => '>= 3.2, < 5.0',
            'gem'       => 'rbnacl'
          }
        ]
      end

      let(:text_html) do
        <<-EOS.chomp
<table><tr><th>newest</th><th>requested</th><th>gem</th></tr><tr><td>1.6.6</td><td>~&gt; 1.4</td><td>faker</td></tr><tr><td>3.4.6</td><td>= 1.2.0</td><td>hashie</td></tr><tr><td>2.3.1</td><td></td><td>headless</td></tr><tr><td>5.0.0</td><td>&gt;= 3.2, &lt; 5.0</td><td>rbnacl</td></tr></table>
        EOS
      end

      let(:text_html_pretty) do
        <<-EOS.chomp
<table>
  <tr>
    <th>newest</th>
    <th>requested</th>
    <th>gem</th>
  </tr>
  <tr>
    <td>1.6.6</td>
    <td>~&gt; 1.4</td>
    <td>faker</td>
  </tr>
  <tr>
    <td>3.4.6</td>
    <td>= 1.2.0</td>
    <td>hashie</td>
  </tr>
  <tr>
    <td>2.3.1</td>
    <td></td>
    <td>headless</td>
  </tr>
  <tr>
    <td>5.0.0</td>
    <td>&gt;= 3.2, &lt; 5.0</td>
    <td>rbnacl</td>
  </tr>
</table>
        EOS
      end

      before do
        formatter.instance_variable_set(:@outdated_gems, outdated_gems)
      end

      context 'when @pretty is false and @style is unicode' do
        it { is_expected.to eq text_html }
      end

      context 'when @pretty is true and @style is unicode' do
        let(:pretty) { true }

        it { is_expected.to eq text_html_pretty }
      end

      context 'when @pretty is false and @style is ascii' do
        let(:style) { 'ascii' }

        it { is_expected.to eq text_html }
      end

      context 'when @pretty is true and @style is ascii' do
        let(:pretty) { true }
        let(:style) { 'ascii' }

        it { is_expected.to eq text_html_pretty }
      end
    end
  end
end
