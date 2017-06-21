RSpec.describe BundleOutdatedFormatter::Formatter do
  let(:format) { 'markdown' }
  let(:pretty) { false }
  let(:formatter) { described_class.new(format: format, pretty: pretty) }

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

  let(:text_markdown) do
    <<-EOS.chomp
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
| faker | 1.6.6 | 1.6.5 | ~> 1.4 | development, test |
| hashie | 3.4.6 | 1.2.0 | = 1.2.0 | default |
| headless | 2.3.1 | 2.2.3 | | |
    EOS
  end

  let(:text_json) do
    <<-EOS.chomp
[{"gem":"faker","newest":"1.6.6","installed":"1.6.5","requested":"~> 1.4","groups":"development, test"},{"gem":"hashie","newest":"3.4.6","installed":"1.2.0","requested":"= 1.2.0","groups":"default"},{"gem":"headless","newest":"2.3.1","installed":"2.2.3","requested":"","groups":""}]
    EOS
  end

  let(:text_json_pretty) do
    <<-EOS.chomp
[
  {
    "gem": "faker",
    "newest": "1.6.6",
    "installed": "1.6.5",
    "requested": "~> 1.4",
    "groups": "development, test"
  },
  {
    "gem": "hashie",
    "newest": "3.4.6",
    "installed": "1.2.0",
    "requested": "= 1.2.0",
    "groups": "default"
  },
  {
    "gem": "headless",
    "newest": "2.3.1",
    "installed": "2.2.3",
    "requested": "",
    "groups": ""
  }
]
    EOS
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

  let(:text_csv) do
    <<-EOS.chomp
"gem","newest","installed","requested","groups"
"faker","1.6.6","1.6.5","~> 1.4","development, test"
"hashie","3.4.6","1.2.0","= 1.2.0","default"
"headless","2.3.1","2.2.3","",""
    EOS
  end

  let(:text_xml) do
    <<-EOS.chomp
<?xml version='1.0' encoding='UTF-8'?><gems><outdated><gem>faker</gem><newest>1.6.6</newest><installed>1.6.5</installed><requested>~> 1.4</requested><groups>development, test</groups></outdated><outdated><gem>hashie</gem><newest>3.4.6</newest><installed>1.2.0</installed><requested>= 1.2.0</requested><groups>default</groups></outdated><outdated><gem>headless</gem><newest>2.3.1</newest><installed>2.2.3</installed><requested></requested><groups></groups></outdated></gems>
    EOS
  end

  let(:text_xml_pretty) do
    <<-EOS.chomp
<?xml version='1.0' encoding='UTF-8'?>
<gems>
  <outdated>
    <gem>faker</gem>
    <newest>1.6.6</newest>
    <installed>1.6.5</installed>
    <requested>~> 1.4</requested>
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
</gems>
    EOS
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

  describe '.new' do
    describe '@format' do
      subject { formatter.instance_variable_get(:@format) }

      context "given 'markdown'" do
        let(:format) { 'markdown' }
        it { is_expected.to eq 'markdown' }
      end

      context "given 'json'" do
        let(:format) { 'json' }
        it { is_expected.to eq 'json' }
      end

      context "given 'yaml'" do
        let(:format) { 'yaml' }
        it { is_expected.to eq 'yaml' }
      end

      context "given 'csv'" do
        let(:format) { 'csv' }
        it { is_expected.to eq 'csv' }
      end

      context "given 'xml'" do
        let(:format) { 'xml' }
        it { is_expected.to eq 'xml' }
      end

      context "given 'html'" do
        let(:format) { 'html' }
        it { is_expected.to eq 'html' }
      end

      context "given 'aaa'" do
        let(:format) { 'aaa' }
        it { is_expected.to eq 'aaa' }
      end

      context 'given nil' do
        let(:format) { nil }
        it { is_expected.to be_nil }
      end
    end

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

  describe '#convert' do
    before do
      formatter.instance_variable_set(:@outdated_gems, outdated_gems)
    end

    subject { formatter.convert }

    context "when @format is 'markdown'" do
      before do
        formatter.instance_variable_set(:@format, 'markdown')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_markdown }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_markdown }
      end
    end

    context "when @format is 'json'" do
      before do
        formatter.instance_variable_set(:@format, 'json')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_json }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_json_pretty }
      end
    end

    context "when @format is 'yaml'" do
      before do
        formatter.instance_variable_set(:@format, 'yaml')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_yaml }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_yaml }
      end
    end

    context "when @format is 'csv'" do
      before do
        formatter.instance_variable_set(:@format, 'csv')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_csv }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_csv }
      end
    end

    context "when @format is 'xml'" do
      before do
        formatter.instance_variable_set(:@format, 'xml')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_xml }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_xml_pretty }
      end
    end

    context "when @format is 'html'" do
      before do
        formatter.instance_variable_set(:@format, 'html')
      end

      context 'when @pretty is false' do
        it { is_expected.to eq text_html }
      end

      context 'when @pretty is true' do
        before do
          formatter.instance_variable_set(:@pretty, true)
        end

        it { is_expected.to eq text_html_pretty }
      end
    end

    context "when @format is 'aaa'" do
      before do
        formatter.instance_variable_set(:@format, 'aaa')
      end

      it { is_expected.to eq '' }
    end

    context 'when @format is nil' do
      before do
        formatter.instance_variable_set(:@format, nil)
      end

      it { is_expected.to eq '' }
    end
  end
end
