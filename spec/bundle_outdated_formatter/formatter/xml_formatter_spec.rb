RSpec.describe BundleOutdatedFormatter::XMLFormatter do
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

  let(:text_xml) do
    <<-EOS.chomp
<?xml version="1.0" encoding="UTF-8"?><gems><outdated><gem>faker</gem><newest>1.6.6</newest><installed>1.6.5</installed><requested>~&gt; 1.4</requested><groups>development, test</groups></outdated><outdated><gem>hashie</gem><newest>3.4.6</newest><installed>1.2.0</installed><requested>= 1.2.0</requested><groups>default</groups></outdated><outdated><gem>headless</gem><newest>2.3.1</newest><installed>2.2.3</installed><requested></requested><groups></groups></outdated><outdated><gem>rbnacl</gem><newest>5.0.0</newest><installed>4.0.2</installed><requested>&gt;= 3.2, &lt; 5.0</requested><groups></groups></outdated></gems>
    EOS
  end

  let(:text_xml_pretty) do
    <<-EOS.chomp
<?xml version="1.0" encoding="UTF-8"?>
<gems>
  <outdated>
    <gem>faker</gem>
    <newest>1.6.6</newest>
    <installed>1.6.5</installed>
    <requested>~&gt; 1.4</requested>
    <groups>development, test</groups>
  </outdated>
  <outdated>
    <gem>hashie</gem>
    <newest>3.4.6</newest>
    <installed>1.2.0</installed>
    <requested>= 1.2.0</requested>
    <groups>default</groups>
  </outdated>
  <outdated>
    <gem>headless</gem>
    <newest>2.3.1</newest>
    <installed>2.2.3</installed>
    <requested></requested>
    <groups></groups>
  </outdated>
  <outdated>
    <gem>rbnacl</gem>
    <newest>5.0.0</newest>
    <installed>4.0.2</installed>
    <requested>&gt;= 3.2, &lt; 5.0</requested>
    <groups></groups>
  </outdated>
</gems>
    EOS
  end

  let(:text_xml_empty) { '<?xml version="1.0" encoding="UTF-8"?><gems></gems>' }

  describe '#convert' do
    before do
      formatter.instance_variable_set(:@outdated_gems, outdated_gems)
    end

    subject { formatter.convert }

    context 'when @pretty is false and @style is unicode' do
      it { is_expected.to eq text_xml }
    end

    context 'when @pretty is true and @style is unicode' do
      let(:pretty) { true }
      it { is_expected.to eq text_xml_pretty }
    end

    context 'when @pretty is false and @style is ascii' do
      let(:style) { 'ascii' }
      it { is_expected.to eq text_xml }
    end

    context 'when @pretty is true and @style is ascii' do
      let(:pretty) { true }
      let(:style) { 'ascii' }
      it { is_expected.to eq text_xml_pretty }
    end

    context 'when no outdated gems' do
      let(:outdated_gems) { [] }
      it { is_expected.to eq text_xml_empty }
    end
  end
end
