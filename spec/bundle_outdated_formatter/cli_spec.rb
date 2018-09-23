RSpec.describe BundleOutdatedFormatter::CLI do
  let(:stdin) do
    <<-EOS
Warning: the running version of Bundler (1.16.1) is older than the version that created the lockfile (1.16.2). We suggest you upgrade to the latest version of Bundler by running `gem install bundler`.
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

  let(:stdout_terminal_unicode) do
    <<-EOS
┌──────────┬────────┬───────────┬───────────┬───────────────────┐
│ gem      │ newest │ installed │ requested │ groups            │
├──────────┼────────┼───────────┼───────────┼───────────────────┤
│ faker    │ 1.6.6  │ 1.6.5     │ ~> 1.4    │ development, test │
│ hashie   │ 3.4.6  │ 1.2.0     │ = 1.2.0   │ default           │
│ headless │ 2.3.1  │ 2.2.3     │           │                   │
└──────────┴────────┴───────────┴───────────┴───────────────────┘
    EOS
  end

  let(:stdout_terminal_ascii) do
    <<-EOS
+----------+--------+-----------+-----------+-------------------+
| gem      | newest | installed | requested | groups            |
+----------+--------+-----------+-----------+-------------------+
| faker    | 1.6.6  | 1.6.5     | ~> 1.4    | development, test |
| hashie   | 3.4.6  | 1.2.0     | = 1.2.0   | default           |
| headless | 2.3.1  | 2.2.3     |           |                   |
+----------+--------+-----------+-----------+-------------------+
    EOS
  end

  let(:stdout_markdown) do
    <<-EOS
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
| faker | 1.6.6 | 1.6.5 | ~> 1.4 | development, test |
| hashie | 3.4.6 | 1.2.0 | = 1.2.0 | default |
| headless | 2.3.1 | 2.2.3 | | |
    EOS
  end

  let(:stdout_json) do
    <<-EOS
[{"gem":"faker","newest":"1.6.6","installed":"1.6.5","requested":"~> 1.4","groups":"development, test"},{"gem":"hashie","newest":"3.4.6","installed":"1.2.0","requested":"= 1.2.0","groups":"default"},{"gem":"headless","newest":"2.3.1","installed":"2.2.3","requested":"","groups":""}]
    EOS
  end

  let(:stdout_json_pretty) do
    <<-EOS
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

  let(:stdout_yaml) do
    <<-EOS
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

  let(:stdout_csv) do
    <<-EOS
"gem","newest","installed","requested","groups"
"faker","1.6.6","1.6.5","~> 1.4","development, test"
"hashie","3.4.6","1.2.0","= 1.2.0","default"
"headless","2.3.1","2.2.3","",""
    EOS
  end

  let(:stdout_tsv) do
    <<-EOS
"gem"	"newest"	"installed"	"requested"	"groups"
"faker"	"1.6.6"	"1.6.5"	"~> 1.4"	"development, test"
"hashie"	"3.4.6"	"1.2.0"	"= 1.2.0"	"default"
"headless"	"2.3.1"	"2.2.3"	""	""
    EOS
  end

  let(:stdout_xml) do
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?><gems><outdated><gem>faker</gem><newest>1.6.6</newest><installed>1.6.5</installed><requested>~&gt; 1.4</requested><groups>development, test</groups></outdated><outdated><gem>hashie</gem><newest>3.4.6</newest><installed>1.2.0</installed><requested>= 1.2.0</requested><groups>default</groups></outdated><outdated><gem>headless</gem><newest>2.3.1</newest><installed>2.2.3</installed><requested></requested><groups></groups></outdated></gems>
    EOS
  end

  let(:stdout_xml_pretty) do
    <<-EOS
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
</gems>
    EOS
  end

  let(:stdout_html) do
    <<-EOS
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr><tr><td>faker</td><td>1.6.6</td><td>1.6.5</td><td>~&gt; 1.4</td><td>development, test</td></tr><tr><td>hashie</td><td>3.4.6</td><td>1.2.0</td><td>= 1.2.0</td><td>default</td></tr><tr><td>headless</td><td>2.3.1</td><td>2.2.3</td><td></td><td></td></tr></table>
    EOS
  end

  let(:stdout_html_pretty) do
    <<-EOS
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
</table>
    EOS
  end

  let(:help) do
    <<-EOS
Commands:
  #{command} help [COMMAND]          # Describe available commands or one specific command
  #{command} output                  # Format output of `bundle outdated`
  #{command} version, -v, --version  # Print the version

    EOS
  end

  shared_examples_for 'terminal format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options
      case options[:style]
      when :unicode
        it { is_expected.to output(stdout_terminal_unicode).to_stdout }
      when :ascii
        it { is_expected.to output(stdout_terminal_ascii).to_stdout }
      else
        it { is_expected.to output(stdout_terminal_unicode).to_stdout }
      end
    end
  end

  shared_examples_for 'markdown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_markdown).to_stdout }
  end

  shared_examples_for 'json format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { is_expected.to output(stdout_json_pretty).to_stdout }
    else
      it { is_expected.to output(stdout_json).to_stdout }
    end
  end

  shared_examples_for 'yaml format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_yaml).to_stdout }
  end

  shared_examples_for 'csv format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_csv).to_stdout }
  end

  shared_examples_for 'tsv format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_tsv).to_stdout }
  end

  shared_examples_for 'xml format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { is_expected.to output(stdout_xml_pretty).to_stdout }
    else
      it { is_expected.to output(stdout_xml).to_stdout }
    end
  end

  shared_examples_for 'html format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { is_expected.to output(stdout_html_pretty).to_stdout }
    else
      it { is_expected.to output(stdout_html).to_stdout }
    end
  end

  shared_examples_for 'unknown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to raise_error(BundleOutdatedFormatter::UnknownFormatError, error_message) }
  end

  shared_examples_for 'unknown style' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to raise_error(BundleOutdatedFormatter::UnknownStyleError, error_message) }
  end

  shared_examples_for 'a `help` command' do
    before do
      expect(File).to receive(:basename).with($PROGRAM_NAME).and_return(command).at_least(:once)
    end

    it { is_expected.to output(help).to_stdout }
  end

  describe '.start' do
    let(:command) { 'bof' }

    subject { -> { described_class.start(thor_args) } }

    context 'given `output`' do
      let(:thor_args) { %w[output] }
      it_behaves_like 'terminal format'
    end

    context 'given ``' do
      let(:thor_args) { %w[] }
      it_behaves_like 'terminal format'
    end

    context 'given `output --format terminal`' do
      let(:thor_args) { %w[output --format terminal] }
      it_behaves_like 'terminal format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f terminal`' do
      let(:thor_args) { %w[output -f terminal] }
      it_behaves_like 'terminal format'
    end

    context 'given `output --format terminal --pretty`' do
      let(:thor_args) { %w[output --format terminal --pretty] }
      it_behaves_like 'terminal format'
    end

    context 'given `output -f terminal -p`' do
      let(:thor_args) { %w[output -f terminal -p] }
      it_behaves_like 'terminal format'
    end

    context 'given `output --format terminal --style unicode`' do
      let(:thor_args) { %w[output --format terminal --style unicode] }
      it_behaves_like 'terminal format'
    end

    context 'given `output -f terminal -s unicode`' do
      let(:thor_args) { %w[output -f terminal -s unicode] }
      it_behaves_like 'terminal format'
    end

    context 'given `output --format terminal --style ascii`' do
      let(:thor_args) { %w[output --format terminal --style ascii] }
      it_behaves_like 'terminal format', style: :ascii
    end

    context 'given `output -f terminal -s ascii`' do
      let(:thor_args) { %w[output -f terminal -s ascii] }
      it_behaves_like 'terminal format', style: :ascii
    end

    context 'given `output --format terminal --pretty --style unicode`' do
      let(:thor_args) { %w[output --format terminal --pretty --style unicode] }
      it_behaves_like 'terminal format'
    end

    context 'given `output --format terminal --pretty --style ascii`' do
      let(:thor_args) { %w[output --format terminal --pretty --style ascii] }
      it_behaves_like 'terminal format', style: :ascii
    end

    context 'given `output --format markdown`' do
      let(:thor_args) { %w[output --format markdown] }
      it_behaves_like 'markdown format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f markdown`' do
      let(:thor_args) { %w[output -f markdown] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format markdown --pretty`' do
      let(:thor_args) { %w[output --format markdown --pretty] }
      it_behaves_like 'markdown format'
    end

    context 'given `output -f markdown -p`' do
      let(:thor_args) { %w[output -f markdown -p] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format markdown --style unicode`' do
      let(:thor_args) { %w[output --format markdown --style unicode] }
      it_behaves_like 'markdown format'
    end

    context 'given `output -f markdown -s unicode`' do
      let(:thor_args) { %w[output -f markdown -s unicode] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format markdown --style ascii`' do
      let(:thor_args) { %w[output --format markdown --style ascii] }
      it_behaves_like 'markdown format'
    end

    context 'given `output -f markdown -s ascii`' do
      let(:thor_args) { %w[output -f markdown -s ascii] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format markdown --pretty --style unicode`' do
      let(:thor_args) { %w[output --format markdown --pretty --style unicode] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format markdown --pretty --style ascii`' do
      let(:thor_args) { %w[output --format markdown --pretty --style ascii] }
      it_behaves_like 'markdown format'
    end

    context 'given `output --format json`' do
      let(:thor_args) { %w[output --format json] }
      it_behaves_like 'json format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f json`' do
      let(:thor_args) { %w[output -f json] }
      it_behaves_like 'json format'
    end

    context 'given `output --format json --pretty`' do
      let(:thor_args) { %w[output --format json --pretty] }
      it_behaves_like 'json format', pretty: true
    end

    context 'given `output -f json -p`' do
      let(:thor_args) { %w[output -f json -p] }
      it_behaves_like 'json format', pretty: true
    end

    context 'given `output --format json --style unicode`' do
      let(:thor_args) { %w[output --format json --style unicode] }
      it_behaves_like 'json format'
    end

    context 'given `output -f json -s unicode`' do
      let(:thor_args) { %w[output -f json -s unicode] }
      it_behaves_like 'json format'
    end

    context 'given `output --format json --style ascii`' do
      let(:thor_args) { %w[output --format json --style ascii] }
      it_behaves_like 'json format'
    end

    context 'given `output -f json -s ascii`' do
      let(:thor_args) { %w[output -f json -s ascii] }
      it_behaves_like 'json format'
    end

    context 'given `output --format json --pretty --style unicode`' do
      let(:thor_args) { %w[output --format json --pretty --style unicode] }
      it_behaves_like 'json format', pretty: true
    end

    context 'given `output --format json --pretty --style ascii`' do
      let(:thor_args) { %w[output --format json --pretty --style ascii] }
      it_behaves_like 'json format', pretty: true
    end

    context 'given `output --format yaml`' do
      let(:thor_args) { %w[output --format yaml] }
      it_behaves_like 'yaml format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f yaml`' do
      let(:thor_args) { %w[output -f yaml] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format yaml --pretty`' do
      let(:thor_args) { %w[output --format yaml --pretty] }
      it_behaves_like 'yaml format'
    end

    context 'given `output -f yaml -p`' do
      let(:thor_args) { %w[output -f yaml -p] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format yaml --style unicode`' do
      let(:thor_args) { %w[output --format yaml --style unicode] }
      it_behaves_like 'yaml format'
    end

    context 'given `output -f yaml -s unicode`' do
      let(:thor_args) { %w[output -f yaml -s unicode] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format yaml --style ascii`' do
      let(:thor_args) { %w[output --format yaml --style ascii] }
      it_behaves_like 'yaml format'
    end

    context 'given `output -f yaml -s ascii`' do
      let(:thor_args) { %w[output -f yaml -s ascii] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format yaml --pretty --style unicode`' do
      let(:thor_args) { %w[output --format yaml --pretty --style unicode] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format yaml --pretty --style ascii`' do
      let(:thor_args) { %w[output --format yaml --pretty --style ascii] }
      it_behaves_like 'yaml format'
    end

    context 'given `output --format csv`' do
      let(:thor_args) { %w[output --format csv] }
      it_behaves_like 'csv format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f csv`' do
      let(:thor_args) { %w[output -f csv] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format csv --pretty`' do
      let(:thor_args) { %w[output --format csv --pretty] }
      it_behaves_like 'csv format'
    end

    context 'given `output -f csv -p`' do
      let(:thor_args) { %w[output -f csv -p] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format csv --style unicode`' do
      let(:thor_args) { %w[output --format csv --style unicode] }
      it_behaves_like 'csv format'
    end

    context 'given `output -f csv -s unicode`' do
      let(:thor_args) { %w[output -f csv -s unicode] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format csv --style ascii`' do
      let(:thor_args) { %w[output --format csv --style ascii] }
      it_behaves_like 'csv format'
    end

    context 'given `output -f csv -s ascii`' do
      let(:thor_args) { %w[output -f csv -s ascii] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format csv --pretty --style unicode`' do
      let(:thor_args) { %w[output --format csv --pretty --style unicode] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format csv --pretty --style ascii`' do
      let(:thor_args) { %w[output --format csv --pretty --style ascii] }
      it_behaves_like 'csv format'
    end

    context 'given `output --format tsv`' do
      let(:thor_args) { %w[output --format tsv] }
      it_behaves_like 'tsv format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f tsv`' do
      let(:thor_args) { %w[output -f tsv] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format tsv --pretty`' do
      let(:thor_args) { %w[output --format tsv --pretty] }
      it_behaves_like 'tsv format'
    end

    context 'given `output -f tsv -p`' do
      let(:thor_args) { %w[output -f tsv -p] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format tsv --style unicode`' do
      let(:thor_args) { %w[output --format tsv --style unicode] }
      it_behaves_like 'tsv format'
    end

    context 'given `output -f tsv -s unicode`' do
      let(:thor_args) { %w[output -f tsv -s unicode] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format tsv --style ascii`' do
      let(:thor_args) { %w[output --format tsv --style ascii] }
      it_behaves_like 'tsv format'
    end

    context 'given `output -f tsv -s ascii`' do
      let(:thor_args) { %w[output -f tsv -s ascii] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format tsv --pretty --style unicode`' do
      let(:thor_args) { %w[output --format tsv --pretty --style unicode] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format tsv --pretty --style ascii`' do
      let(:thor_args) { %w[output --format tsv --pretty --style ascii] }
      it_behaves_like 'tsv format'
    end

    context 'given `output --format xml`' do
      let(:thor_args) { %w[output --format xml] }
      it_behaves_like 'xml format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f xml`' do
      let(:thor_args) { %w[output -f xml] }
      it_behaves_like 'xml format'
    end

    context 'given `output --format xml --pretty`' do
      let(:thor_args) { %w[output --format xml --pretty] }
      it_behaves_like 'xml format', pretty: true
    end

    context 'given `output -f xml -p`' do
      let(:thor_args) { %w[output -f xml -p] }
      it_behaves_like 'xml format', pretty: true
    end

    context 'given `output --format xml --style unicode`' do
      let(:thor_args) { %w[output --format xml --style unicode] }
      it_behaves_like 'xml format'
    end

    context 'given `output -f xml -s unicode`' do
      let(:thor_args) { %w[output -f xml -s unicode] }
      it_behaves_like 'xml format'
    end

    context 'given `output --format xml --style ascii`' do
      let(:thor_args) { %w[output --format xml --style ascii] }
      it_behaves_like 'xml format'
    end

    context 'given `output -f xml -s ascii`' do
      let(:thor_args) { %w[output -f xml -s ascii] }
      it_behaves_like 'xml format'
    end

    context 'given `output --format xml --pretty --style unicode`' do
      let(:thor_args) { %w[output --format xml --pretty --style unicode] }
      it_behaves_like 'xml format', pretty: true
    end

    context 'given `output --format xml --pretty --style ascii`' do
      let(:thor_args) { %w[output --format xml --pretty --style ascii] }
      it_behaves_like 'xml format', pretty: true
    end

    context 'given `output --format html`' do
      let(:thor_args) { %w[output --format html] }
      it_behaves_like 'html format'

      context 'without STDIN' do
        it { is_expected.not_to output.to_stdout }
      end
    end

    context 'given `output -f html`' do
      let(:thor_args) { %w[output -f html] }
      it_behaves_like 'html format'
    end

    context 'given `output --format html --pretty`' do
      let(:thor_args) { %w[output --format html --pretty] }
      it_behaves_like 'html format', pretty: true
    end

    context 'given `output -f html -p`' do
      let(:thor_args) { %w[output -f html -p] }
      it_behaves_like 'html format', pretty: true
    end

    context 'given `output --format html --style unicode`' do
      let(:thor_args) { %w[output --format html --style unicode] }
      it_behaves_like 'html format'
    end

    context 'given `output -f html -s unicode`' do
      let(:thor_args) { %w[output -f html -s unicode] }
      it_behaves_like 'html format'
    end

    context 'given `output --format html --style ascii`' do
      let(:thor_args) { %w[output --format html --style ascii] }
      it_behaves_like 'html format'
    end

    context 'given `output -f html -s ascii`' do
      let(:thor_args) { %w[output -f html -s ascii] }
      it_behaves_like 'html format'
    end

    context 'given `output --format html --pretty --style unicode`' do
      let(:thor_args) { %w[output --format html --pretty --style unicode] }
      it_behaves_like 'html format', pretty: true
    end

    context 'given `output --format html --pretty --style ascii`' do
      let(:thor_args) { %w[output --format html --pretty --style ascii] }
      it_behaves_like 'html format', pretty: true
    end

    context 'given `output` --format aaa' do
      let(:thor_args) { %w[output --format aaa] }
      let(:error_message) { 'aaa' }
      it_behaves_like 'unknown format'
    end

    context 'given `output` --style aaa' do
      let(:thor_args) { %w[output --style aaa] }
      let(:error_message) { 'aaa' }
      it_behaves_like 'unknown style'
    end

    context 'given `version`' do
      let(:command) { 'bundle_outdated_formatter' }
      let(:thor_args) { %w[version] }
      it { is_expected.to output("#{command} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'given `--version`' do
      let(:command) { 'bundle_outdated_formatter' }
      let(:thor_args) { %w[--version] }
      it { is_expected.to output("#{command} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'given `-v`' do
      let(:command) { 'bundle_outdated_formatter' }
      let(:thor_args) { %w[-v] }
      it { is_expected.to output("#{command} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'given `help`' do
      let(:thor_args) { %w[help] }
      it_behaves_like 'a `help` command'
    end

    context 'given `--help`' do
      let(:thor_args) { %w[--help] }
      it_behaves_like 'a `help` command'
    end

    context 'given `-h`' do
      let(:thor_args) { %w[-h] }
      it_behaves_like 'a `help` command'
    end

    context 'given `h`' do
      let(:thor_args) { %w[h] }
      it_behaves_like 'a `help` command'
    end

    context 'given `he`' do
      let(:thor_args) { %w[he] }
      it_behaves_like 'a `help` command'
    end

    context 'given `hel`' do
      let(:thor_args) { %w[hel] }
      it_behaves_like 'a `help` command'
    end

    context 'given `help output`' do
      let(:thor_args) { %w[help output] }
      let(:help) do
        <<-EOS
Usage:
  #{command} output

Options:
  -f, [--format=FORMAT]          # Format. (terminal, markdown, json, yaml, csv, tsv, xml, html)
                                 # Default: terminal
  -p, [--pretty], [--no-pretty]  # `true` if pretty output.
  -s, [--style=STYLE]            # Terminal table style. (unicode, ascii)
                                 # Default: unicode

Format output of `bundle outdated`
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `help version`' do
      let(:thor_args) { %w[help version] }
      let(:help) do
        <<-EOS
Usage:
  #{command} version, -v, --version

Print the version
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `help help`' do
      let(:thor_args) { %w[help help] }
      let(:help) do
        <<-EOS
Usage:
  #{command} help [COMMAND]

Describe available commands or one specific command
        EOS
      end
      it_behaves_like 'a `help` command'
    end

    context 'given `abc`' do
      let(:thor_args) { %w[abc] }
      it { is_expected.to output(%(Could not find command "abc".\n)).to_stderr }
    end

    context 'given `helpp`' do
      let(:thor_args) { %w[helpp] }
      it { is_expected.to output(%(Could not find command "helpp".\n)).to_stderr }
    end
  end
end
