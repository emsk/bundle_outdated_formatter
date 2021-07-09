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
  * hashie (newest 3.4.6, installed 1.2.0, requested = 1.2.0) in group "default"
  * headless (newest 2.3.1, installed 2.2.3)
    EOS
  end

  let(:stdin_with_table_format) do
    <<-EOS
Fetching gem metadata from https://rubygems.org/..........
Resolving dependencies....

Gem      Current  Latest   Requested  Groups
faker    1.6.5    1.6.6    ~> 1.4     development, test
hashie   1.2.0    3.4.6    = 1.2.0    default
headless 2.2.3    2.3.1
    EOS
  end

  let(:stdin_without_outdated) do
    <<-EOS
Fetching gem metadata from https://rubygems.org/..........
Fetching gem metadata from https://rubygems.org/.
Resolving dependencies...

Bundle up to date!
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

  let(:stdout_terminal_unicode_without_outdated) do
    <<-EOS
┌─────┬────────┬───────────┬───────────┬────────┐
│ gem │ newest │ installed │ requested │ groups │
└─────┴────────┴───────────┴───────────┴────────┘
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

  let(:stdout_terminal_ascii_without_outdated) do
    <<-EOS
+-----+--------+-----------+-----------+--------+
| gem | newest | installed | requested | groups |
+-----+--------+-----------+-----------+--------+
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

  let(:stdout_markdown_without_outdated) do
    <<-EOS
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
    EOS
  end

  let(:stdout_json) do
    <<-EOS
[{"gem":"faker","newest":"1.6.6","installed":"1.6.5","requested":"~> 1.4","groups":"development, test"},{"gem":"hashie","newest":"3.4.6","installed":"1.2.0","requested":"= 1.2.0","groups":"default"},{"gem":"headless","newest":"2.3.1","installed":"2.2.3","requested":"","groups":""}]
    EOS
  end

  let(:stdout_json_without_outdated) do
    <<-EOS
[]
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

  let(:stdout_json_pretty_without_outdated) do
    <<-EOS
[

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

  let(:stdout_yaml_without_outdated) do
    <<-EOS
--- []
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

  let(:stdout_csv_without_outdated) do
    <<-EOS
"gem","newest","installed","requested","groups"
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

  let(:stdout_tsv_without_outdated) do
    <<-EOS
"gem"	"newest"	"installed"	"requested"	"groups"
    EOS
  end

  let(:stdout_xml) do
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?><gems><outdated><gem>faker</gem><newest>1.6.6</newest><installed>1.6.5</installed><requested>~&gt; 1.4</requested><groups>development, test</groups></outdated><outdated><gem>hashie</gem><newest>3.4.6</newest><installed>1.2.0</installed><requested>= 1.2.0</requested><groups>default</groups></outdated><outdated><gem>headless</gem><newest>2.3.1</newest><installed>2.2.3</installed><requested></requested><groups></groups></outdated></gems>
    EOS
  end

  let(:stdout_xml_without_outdated) do
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?><gems></gems>
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

  let(:stdout_xml_pretty_without_outdated) do
    <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<gems></gems>
    EOS
  end

  let(:stdout_html) do
    <<-EOS
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr><tr><td>faker</td><td>1.6.6</td><td>1.6.5</td><td>~&gt; 1.4</td><td>development, test</td></tr><tr><td>hashie</td><td>3.4.6</td><td>1.2.0</td><td>= 1.2.0</td><td>default</td></tr><tr><td>headless</td><td>2.3.1</td><td>2.2.3</td><td></td><td></td></tr></table>
    EOS
  end

  let(:stdout_html_without_outdated) do
    <<-EOS
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr></table>
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

  let(:stdout_html_pretty_without_outdated) do
    <<-EOS
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

  let(:help) do
    <<-EOS
Commands:
  #{command_name} help [COMMAND]          # Describe available commands or one specific command
  #{command_name} output                  # Format output of `bundle outdated`
  #{command_name} version, -v, --version  # Print the version

    EOS
  end

  shared_examples_for 'terminal format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:style] == :ascii
      it { expect { command }.to output(stdout_terminal_ascii).to_stdout }
    else
      it { expect { command }.to output(stdout_terminal_unicode).to_stdout }
    end
  end

  shared_examples_for 'markdown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to output(stdout_markdown).to_stdout }
  end

  shared_examples_for 'json format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { expect { command }.to output(stdout_json_pretty).to_stdout }
    else
      it { expect { command }.to output(stdout_json).to_stdout }
    end
  end

  shared_examples_for 'yaml format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to output(stdout_yaml).to_stdout }
  end

  shared_examples_for 'csv format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to output(stdout_csv).to_stdout }
  end

  shared_examples_for 'tsv format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to output(stdout_tsv).to_stdout }
  end

  shared_examples_for 'xml format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { expect { command }.to output(stdout_xml_pretty).to_stdout }
    else
      it { expect { command }.to output(stdout_xml).to_stdout }
    end
  end

  shared_examples_for 'html format' do |options|
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    if options && options[:pretty]
      it { expect { command }.to output(stdout_html_pretty).to_stdout }
    else
      it { expect { command }.to output(stdout_html).to_stdout }
    end
  end

  shared_examples_for 'unknown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to raise_error(BundleOutdatedFormatter::UnknownFormatError, error_message) }
  end

  shared_examples_for 'unknown style' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to raise_error(BundleOutdatedFormatter::UnknownStyleError, error_message) }
  end

  shared_examples_for 'unknown column' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to raise_error(BundleOutdatedFormatter::UnknownColumnError, error_message) }
  end

  shared_examples_for 'required column' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { expect { command }.to output("No value provided for option '--column'\n").to_stderr }
  end

  shared_examples_for 'a `help` command' do
    before do
      allow(File).to receive(:basename).with($PROGRAM_NAME).and_return(command_name)
    end

    it do
      command
      expect(File).to have_received(:basename).with($PROGRAM_NAME).at_least(:once)
    end

    it { expect { command }.to output(help).to_stdout }
  end

  describe '.start' do
    subject(:command) { described_class.start(thor_args) }

    let(:command_name) { 'bof' }
    let(:gem_name) { 'bundle_outdated_formatter' }

    context 'with `output`' do
      let(:thor_args) { %w[output] }

      it_behaves_like 'terminal format'
    end

    context 'with ``' do
      let(:thor_args) { %w[] }

      it_behaves_like 'terminal format'
    end

    context 'with `output --format terminal`' do
      let(:thor_args) { %w[output --format terminal] }

      it_behaves_like 'terminal format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'terminal format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_terminal_unicode) { stdout_terminal_unicode_without_outdated }

        it_behaves_like 'terminal format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f terminal`' do
      let(:thor_args) { %w[output -f terminal] }

      it_behaves_like 'terminal format'
    end

    context 'with `output --format terminal --pretty`' do
      let(:thor_args) { %w[output --format terminal --pretty] }

      it_behaves_like 'terminal format'
    end

    context 'with `output -f terminal -p`' do
      let(:thor_args) { %w[output -f terminal -p] }

      it_behaves_like 'terminal format'
    end

    context 'with `output --format terminal --style unicode`' do
      let(:thor_args) { %w[output --format terminal --style unicode] }

      it_behaves_like 'terminal format'
    end

    context 'with `output -f terminal -s unicode`' do
      let(:thor_args) { %w[output -f terminal -s unicode] }

      it_behaves_like 'terminal format'
    end

    context 'with `output --format terminal --style ascii`' do
      let(:thor_args) { %w[output --format terminal --style ascii] }

      it_behaves_like 'terminal format', style: :ascii

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'terminal format', style: :ascii
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_terminal_ascii) { stdout_terminal_ascii_without_outdated }

        it_behaves_like 'terminal format', style: :ascii
      end
    end

    context 'with `output -f terminal -s ascii`' do
      let(:thor_args) { %w[output -f terminal -s ascii] }

      it_behaves_like 'terminal format', style: :ascii
    end

    context 'with `output --format terminal --pretty --style unicode`' do
      let(:thor_args) { %w[output --format terminal --pretty --style unicode] }

      it_behaves_like 'terminal format'
    end

    context 'with `output --format terminal --pretty --style ascii`' do
      let(:thor_args) { %w[output --format terminal --pretty --style ascii] }

      it_behaves_like 'terminal format', style: :ascii
    end

    context 'with `output --format markdown`' do
      let(:thor_args) { %w[output --format markdown] }

      it_behaves_like 'markdown format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'markdown format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_markdown) { stdout_markdown_without_outdated }

        it_behaves_like 'markdown format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f markdown`' do
      let(:thor_args) { %w[output -f markdown] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format markdown --pretty`' do
      let(:thor_args) { %w[output --format markdown --pretty] }

      it_behaves_like 'markdown format'
    end

    context 'with `output -f markdown -p`' do
      let(:thor_args) { %w[output -f markdown -p] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format markdown --style unicode`' do
      let(:thor_args) { %w[output --format markdown --style unicode] }

      it_behaves_like 'markdown format'
    end

    context 'with `output -f markdown -s unicode`' do
      let(:thor_args) { %w[output -f markdown -s unicode] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format markdown --style ascii`' do
      let(:thor_args) { %w[output --format markdown --style ascii] }

      it_behaves_like 'markdown format'
    end

    context 'with `output -f markdown -s ascii`' do
      let(:thor_args) { %w[output -f markdown -s ascii] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format markdown --pretty --style unicode`' do
      let(:thor_args) { %w[output --format markdown --pretty --style unicode] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format markdown --pretty --style ascii`' do
      let(:thor_args) { %w[output --format markdown --pretty --style ascii] }

      it_behaves_like 'markdown format'
    end

    context 'with `output --format json`' do
      let(:thor_args) { %w[output --format json] }

      it_behaves_like 'json format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'json format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_json) { stdout_json_without_outdated }

        it_behaves_like 'json format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f json`' do
      let(:thor_args) { %w[output -f json] }

      it_behaves_like 'json format'
    end

    context 'with `output --format json --pretty`' do
      let(:thor_args) { %w[output --format json --pretty] }

      it_behaves_like 'json format', pretty: true

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'json format', pretty: true
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_json_pretty) { stdout_json_pretty_without_outdated }

        it_behaves_like 'json format', pretty: true
      end
    end

    context 'with `output -f json -p`' do
      let(:thor_args) { %w[output -f json -p] }

      it_behaves_like 'json format', pretty: true
    end

    context 'with `output --format json --style unicode`' do
      let(:thor_args) { %w[output --format json --style unicode] }

      it_behaves_like 'json format'
    end

    context 'with `output -f json -s unicode`' do
      let(:thor_args) { %w[output -f json -s unicode] }

      it_behaves_like 'json format'
    end

    context 'with `output --format json --style ascii`' do
      let(:thor_args) { %w[output --format json --style ascii] }

      it_behaves_like 'json format'
    end

    context 'with `output -f json -s ascii`' do
      let(:thor_args) { %w[output -f json -s ascii] }

      it_behaves_like 'json format'
    end

    context 'with `output --format json --pretty --style unicode`' do
      let(:thor_args) { %w[output --format json --pretty --style unicode] }

      it_behaves_like 'json format', pretty: true
    end

    context 'with `output --format json --pretty --style ascii`' do
      let(:thor_args) { %w[output --format json --pretty --style ascii] }

      it_behaves_like 'json format', pretty: true
    end

    context 'with `output --format yaml`' do
      let(:thor_args) { %w[output --format yaml] }

      it_behaves_like 'yaml format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'yaml format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_yaml) { stdout_yaml_without_outdated }

        it_behaves_like 'yaml format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f yaml`' do
      let(:thor_args) { %w[output -f yaml] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format yaml --pretty`' do
      let(:thor_args) { %w[output --format yaml --pretty] }

      it_behaves_like 'yaml format'
    end

    context 'with `output -f yaml -p`' do
      let(:thor_args) { %w[output -f yaml -p] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format yaml --style unicode`' do
      let(:thor_args) { %w[output --format yaml --style unicode] }

      it_behaves_like 'yaml format'
    end

    context 'with `output -f yaml -s unicode`' do
      let(:thor_args) { %w[output -f yaml -s unicode] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format yaml --style ascii`' do
      let(:thor_args) { %w[output --format yaml --style ascii] }

      it_behaves_like 'yaml format'
    end

    context 'with `output -f yaml -s ascii`' do
      let(:thor_args) { %w[output -f yaml -s ascii] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format yaml --pretty --style unicode`' do
      let(:thor_args) { %w[output --format yaml --pretty --style unicode] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format yaml --pretty --style ascii`' do
      let(:thor_args) { %w[output --format yaml --pretty --style ascii] }

      it_behaves_like 'yaml format'
    end

    context 'with `output --format csv`' do
      let(:thor_args) { %w[output --format csv] }

      it_behaves_like 'csv format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'csv format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_csv) { stdout_csv_without_outdated }

        it_behaves_like 'csv format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f csv`' do
      let(:thor_args) { %w[output -f csv] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format csv --pretty`' do
      let(:thor_args) { %w[output --format csv --pretty] }

      it_behaves_like 'csv format'
    end

    context 'with `output -f csv -p`' do
      let(:thor_args) { %w[output -f csv -p] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format csv --style unicode`' do
      let(:thor_args) { %w[output --format csv --style unicode] }

      it_behaves_like 'csv format'
    end

    context 'with `output -f csv -s unicode`' do
      let(:thor_args) { %w[output -f csv -s unicode] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format csv --style ascii`' do
      let(:thor_args) { %w[output --format csv --style ascii] }

      it_behaves_like 'csv format'
    end

    context 'with `output -f csv -s ascii`' do
      let(:thor_args) { %w[output -f csv -s ascii] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format csv --pretty --style unicode`' do
      let(:thor_args) { %w[output --format csv --pretty --style unicode] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format csv --pretty --style ascii`' do
      let(:thor_args) { %w[output --format csv --pretty --style ascii] }

      it_behaves_like 'csv format'
    end

    context 'with `output --format tsv`' do
      let(:thor_args) { %w[output --format tsv] }

      it_behaves_like 'tsv format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'tsv format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_tsv) { stdout_tsv_without_outdated }

        it_behaves_like 'tsv format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f tsv`' do
      let(:thor_args) { %w[output -f tsv] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format tsv --pretty`' do
      let(:thor_args) { %w[output --format tsv --pretty] }

      it_behaves_like 'tsv format'
    end

    context 'with `output -f tsv -p`' do
      let(:thor_args) { %w[output -f tsv -p] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format tsv --style unicode`' do
      let(:thor_args) { %w[output --format tsv --style unicode] }

      it_behaves_like 'tsv format'
    end

    context 'with `output -f tsv -s unicode`' do
      let(:thor_args) { %w[output -f tsv -s unicode] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format tsv --style ascii`' do
      let(:thor_args) { %w[output --format tsv --style ascii] }

      it_behaves_like 'tsv format'
    end

    context 'with `output -f tsv -s ascii`' do
      let(:thor_args) { %w[output -f tsv -s ascii] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format tsv --pretty --style unicode`' do
      let(:thor_args) { %w[output --format tsv --pretty --style unicode] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format tsv --pretty --style ascii`' do
      let(:thor_args) { %w[output --format tsv --pretty --style ascii] }

      it_behaves_like 'tsv format'
    end

    context 'with `output --format xml`' do
      let(:thor_args) { %w[output --format xml] }

      it_behaves_like 'xml format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'xml format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_xml) { stdout_xml_without_outdated }

        it_behaves_like 'xml format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f xml`' do
      let(:thor_args) { %w[output -f xml] }

      it_behaves_like 'xml format'
    end

    context 'with `output --format xml --pretty`' do
      let(:thor_args) { %w[output --format xml --pretty] }

      it_behaves_like 'xml format', pretty: true

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'xml format', pretty: true
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_xml_pretty) { stdout_xml_pretty_without_outdated }

        it_behaves_like 'xml format', pretty: true
      end
    end

    context 'with `output -f xml -p`' do
      let(:thor_args) { %w[output -f xml -p] }

      it_behaves_like 'xml format', pretty: true
    end

    context 'with `output --format xml --style unicode`' do
      let(:thor_args) { %w[output --format xml --style unicode] }

      it_behaves_like 'xml format'
    end

    context 'with `output -f xml -s unicode`' do
      let(:thor_args) { %w[output -f xml -s unicode] }

      it_behaves_like 'xml format'
    end

    context 'with `output --format xml --style ascii`' do
      let(:thor_args) { %w[output --format xml --style ascii] }

      it_behaves_like 'xml format'
    end

    context 'with `output -f xml -s ascii`' do
      let(:thor_args) { %w[output -f xml -s ascii] }

      it_behaves_like 'xml format'
    end

    context 'with `output --format xml --pretty --style unicode`' do
      let(:thor_args) { %w[output --format xml --pretty --style unicode] }

      it_behaves_like 'xml format', pretty: true
    end

    context 'with `output --format xml --pretty --style ascii`' do
      let(:thor_args) { %w[output --format xml --pretty --style ascii] }

      it_behaves_like 'xml format', pretty: true
    end

    context 'with `output --format html`' do
      let(:thor_args) { %w[output --format html] }

      it_behaves_like 'html format'

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'html format'
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_html) { stdout_html_without_outdated }

        it_behaves_like 'html format'
      end

      context 'without STDIN' do
        before do
          allow(STDIN).to receive(:tty?).and_return(true)
        end

        it { expect { command }.not_to output.to_stdout }
      end
    end

    context 'with `output -f html`' do
      let(:thor_args) { %w[output -f html] }

      it_behaves_like 'html format'
    end

    context 'with `output --format html --pretty`' do
      let(:thor_args) { %w[output --format html --pretty] }

      it_behaves_like 'html format', pretty: true

      context 'with table format' do
        let(:stdin) { stdin_with_table_format }

        it_behaves_like 'html format', pretty: true
      end

      context 'without outdated' do
        let(:stdin) { stdin_without_outdated }
        let(:stdout_html_pretty) { stdout_html_pretty_without_outdated }

        it_behaves_like 'html format', pretty: true
      end
    end

    context 'with `output -f html -p`' do
      let(:thor_args) { %w[output -f html -p] }

      it_behaves_like 'html format', pretty: true
    end

    context 'with `output --format html --style unicode`' do
      let(:thor_args) { %w[output --format html --style unicode] }

      it_behaves_like 'html format'
    end

    context 'with `output -f html -s unicode`' do
      let(:thor_args) { %w[output -f html -s unicode] }

      it_behaves_like 'html format'
    end

    context 'with `output --format html --style ascii`' do
      let(:thor_args) { %w[output --format html --style ascii] }

      it_behaves_like 'html format'
    end

    context 'with `output -f html -s ascii`' do
      let(:thor_args) { %w[output -f html -s ascii] }

      it_behaves_like 'html format'
    end

    context 'with `output --format html --pretty --style unicode`' do
      let(:thor_args) { %w[output --format html --pretty --style unicode] }

      it_behaves_like 'html format', pretty: true
    end

    context 'with `output --format html --pretty --style ascii`' do
      let(:thor_args) { %w[output --format html --pretty --style ascii] }

      it_behaves_like 'html format', pretty: true
    end

    context 'with `--column newest requested gem`' do
      let(:stdout_terminal_unicode) do
        <<-EOS
┌────────┬───────────┬──────────┐
│ newest │ requested │ gem      │
├────────┼───────────┼──────────┤
│ 1.6.6  │ ~> 1.4    │ faker    │
│ 3.4.6  │ = 1.2.0   │ hashie   │
│ 2.3.1  │           │ headless │
└────────┴───────────┴──────────┘
        EOS
      end

      let(:stdout_terminal_ascii) do
        <<-EOS
+--------+-----------+----------+
| newest | requested | gem      |
+--------+-----------+----------+
| 1.6.6  | ~> 1.4    | faker    |
| 3.4.6  | = 1.2.0   | hashie   |
| 2.3.1  |           | headless |
+--------+-----------+----------+
        EOS
      end

      let(:stdout_markdown) do
        <<-EOS
| newest | requested | gem |
| --- | --- | --- |
| 1.6.6 | ~> 1.4 | faker |
| 3.4.6 | = 1.2.0 | hashie |
| 2.3.1 | | headless |
        EOS
      end

      let(:stdout_json) do
        <<-EOS
[{"newest":"1.6.6","requested":"~> 1.4","gem":"faker"},{"newest":"3.4.6","requested":"= 1.2.0","gem":"hashie"},{"newest":"2.3.1","requested":"","gem":"headless"}]
        EOS
      end

      let(:stdout_json_pretty) do
        <<-EOS
[
  {
    "newest": "1.6.6",
    "requested": "~> 1.4",
    "gem": "faker"
  },
  {
    "newest": "3.4.6",
    "requested": "= 1.2.0",
    "gem": "hashie"
  },
  {
    "newest": "2.3.1",
    "requested": "",
    "gem": "headless"
  }
]
        EOS
      end

      let(:stdout_yaml) do
        <<-EOS
---
- newest: 1.6.6
  requested: "~> 1.4"
  gem: faker
- newest: 3.4.6
  requested: "= 1.2.0"
  gem: hashie
- newest: 2.3.1
  requested: ''
  gem: headless
        EOS
      end

      let(:stdout_csv) do
        <<-EOS
"newest","requested","gem"
"1.6.6","~> 1.4","faker"
"3.4.6","= 1.2.0","hashie"
"2.3.1","","headless"
        EOS
      end

      let(:stdout_tsv) do
        <<-EOS
"newest"	"requested"	"gem"
"1.6.6"	"~> 1.4"	"faker"
"3.4.6"	"= 1.2.0"	"hashie"
"2.3.1"	""	"headless"
        EOS
      end

      let(:stdout_xml) do
        <<-EOS
<?xml version="1.0" encoding="UTF-8"?><gems><outdated><newest>1.6.6</newest><requested>~&gt; 1.4</requested><gem>faker</gem></outdated><outdated><newest>3.4.6</newest><requested>= 1.2.0</requested><gem>hashie</gem></outdated><outdated><newest>2.3.1</newest><requested></requested><gem>headless</gem></outdated></gems>
        EOS
      end

      let(:stdout_xml_pretty) do
        <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<gems>
  <outdated>
    <newest>1.6.6</newest>
    <requested>~&gt; 1.4</requested>
    <gem>faker</gem>
  </outdated>
  <outdated>
    <newest>3.4.6</newest>
    <requested>= 1.2.0</requested>
    <gem>hashie</gem>
  </outdated>
  <outdated>
    <newest>2.3.1</newest>
    <requested></requested>
    <gem>headless</gem>
  </outdated>
</gems>
        EOS
      end

      let(:stdout_html) do
        <<-EOS
<table><tr><th>newest</th><th>requested</th><th>gem</th></tr><tr><td>1.6.6</td><td>~&gt; 1.4</td><td>faker</td></tr><tr><td>3.4.6</td><td>= 1.2.0</td><td>hashie</td></tr><tr><td>2.3.1</td><td></td><td>headless</td></tr></table>
        EOS
      end

      let(:stdout_html_pretty) do
        <<-EOS
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
</table>
        EOS
      end

      context 'with `output`' do
        let(:thor_args) { %w[output --column newest requested gem] }

        it_behaves_like 'terminal format'
      end

      context 'with ``' do
        let(:thor_args) { %w[--column newest requested gem] }

        it_behaves_like 'terminal format'
      end

      context 'with `output --format terminal`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal] }

        it_behaves_like 'terminal format'
      end

      context 'with `output --format terminal --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal --pretty] }

        it_behaves_like 'terminal format'
      end

      context 'with `output --format terminal --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal --style unicode] }

        it_behaves_like 'terminal format'
      end

      context 'with `output --format terminal --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal --style ascii] }

        it_behaves_like 'terminal format', style: :ascii
      end

      context 'with `output --format terminal --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal --pretty --style unicode] }

        it_behaves_like 'terminal format'
      end

      context 'with `output --format terminal --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format terminal --pretty --style ascii] }

        it_behaves_like 'terminal format', style: :ascii
      end

      context 'with `output --format markdown`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format markdown --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown --pretty] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format markdown --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown --style unicode] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format markdown --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown --style ascii] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format markdown --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown --pretty --style unicode] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format markdown --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format markdown --pretty --style ascii] }

        it_behaves_like 'markdown format'
      end

      context 'with `output --format json`' do
        let(:thor_args) { %w[output --column newest requested gem --format json] }

        it_behaves_like 'json format'
      end

      context 'with `output --format json --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format json --pretty] }

        it_behaves_like 'json format', pretty: true
      end

      context 'with `output --format json --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format json --style unicode] }

        it_behaves_like 'json format'
      end

      context 'with `output --format json --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format json --style ascii] }

        it_behaves_like 'json format'
      end

      context 'with `output --format json --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format json --pretty --style unicode] }

        it_behaves_like 'json format', pretty: true
      end

      context 'with `output --format json --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format json --pretty --style ascii] }

        it_behaves_like 'json format', pretty: true
      end

      context 'with `output --format yaml`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format yaml --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml --pretty] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format yaml --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml --style unicode] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format yaml --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml --style ascii] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format yaml --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml --pretty --style unicode] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format yaml --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format yaml --pretty --style ascii] }

        it_behaves_like 'yaml format'
      end

      context 'with `output --format csv`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format csv --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv --pretty] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format csv --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv --style unicode] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format csv --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv --style ascii] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format csv --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv --pretty --style unicode] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format csv --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format csv --pretty --style ascii] }

        it_behaves_like 'csv format'
      end

      context 'with `output --format tsv`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format tsv --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv --pretty] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format tsv --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv --style unicode] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format tsv --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv --style ascii] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format tsv --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv --pretty --style unicode] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format tsv --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format tsv --pretty --style ascii] }

        it_behaves_like 'tsv format'
      end

      context 'with `output --format xml`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml] }

        it_behaves_like 'xml format'
      end

      context 'with `output --format xml --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml --pretty] }

        it_behaves_like 'xml format', pretty: true
      end

      context 'with `output --format xml --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml --style unicode] }

        it_behaves_like 'xml format'
      end

      context 'with `output --format xml --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml --style ascii] }

        it_behaves_like 'xml format'
      end

      context 'with `output --format xml --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml --pretty --style unicode] }

        it_behaves_like 'xml format', pretty: true
      end

      context 'with `output --format xml --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format xml --pretty --style ascii] }

        it_behaves_like 'xml format', pretty: true
      end

      context 'with `output --format html`' do
        let(:thor_args) { %w[output --column newest requested gem --format html] }

        it_behaves_like 'html format'
      end

      context 'with `output --format html --pretty`' do
        let(:thor_args) { %w[output --column newest requested gem --format html --pretty] }

        it_behaves_like 'html format', pretty: true
      end

      context 'with `output --format html --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format html --style unicode] }

        it_behaves_like 'html format'
      end

      context 'with `output --format html --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format html --style ascii] }

        it_behaves_like 'html format'
      end

      context 'with `output --format html --pretty --style unicode`' do
        let(:thor_args) { %w[output --column newest requested gem --format html --pretty --style unicode] }

        it_behaves_like 'html format', pretty: true
      end

      context 'with `output --format html --pretty --style ascii`' do
        let(:thor_args) { %w[output --column newest requested gem --format html --pretty --style ascii] }

        it_behaves_like 'html format', pretty: true
      end
    end

    context 'with `output --format aaa`' do
      let(:thor_args) { %w[output --format aaa] }
      let(:error_message) { 'aaa' }

      it_behaves_like 'unknown format'
    end

    context 'with `output --style aaa`' do
      let(:thor_args) { %w[output --style aaa] }
      let(:error_message) { 'aaa' }

      it_behaves_like 'unknown style'
    end

    context 'with `output --column gem aaa newest`' do
      let(:thor_args) { %w[output --column gem aaa newest] }
      let(:error_message) { '["gem", "aaa", "newest"]' }

      it_behaves_like 'unknown column'
    end

    context 'with `output --column`' do
      let(:thor_args) { %w[output --column] }

      it_behaves_like 'required column'
    end

    context 'with `version`' do
      let(:thor_args) { %w[version] }

      it { expect { command }.to output("#{gem_name} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'with `--version`' do
      let(:thor_args) { %w[--version] }

      it { expect { command }.to output("#{gem_name} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'with `-v`' do
      let(:thor_args) { %w[-v] }

      it { expect { command }.to output("#{gem_name} #{BundleOutdatedFormatter::VERSION}\n").to_stdout }
    end

    context 'with `help`' do
      let(:thor_args) { %w[help] }

      it_behaves_like 'a `help` command'
    end

    context 'with `--help`' do
      let(:thor_args) { %w[--help] }

      it_behaves_like 'a `help` command'
    end

    context 'with `-h`' do
      let(:thor_args) { %w[-h] }

      it_behaves_like 'a `help` command'
    end

    context 'with `h`' do
      let(:thor_args) { %w[h] }

      it_behaves_like 'a `help` command'
    end

    context 'with `he`' do
      let(:thor_args) { %w[he] }

      it_behaves_like 'a `help` command'
    end

    context 'with `hel`' do
      let(:thor_args) { %w[hel] }

      it_behaves_like 'a `help` command'
    end

    context 'with `help output`' do
      let(:thor_args) { %w[help output] }
      let(:help) do
        <<-EOS
Usage:
  #{command_name} output

Options:
  -f, [--format=FORMAT]          # Format. (terminal, markdown, json, yaml, csv, tsv, xml, html)
                                 # Default: terminal
  -p, [--pretty], [--no-pretty]  # `true` if pretty output.
  -s, [--style=STYLE]            # Terminal table style. (unicode, ascii)
                                 # Default: unicode
  -c, [--column=one two three]   # Output columns. (columns are sorted in specified order)
                                 # Default: ["gem", "newest", "installed", "requested", "groups"]

Format output of `bundle outdated`
        EOS
      end

      it_behaves_like 'a `help` command'
    end

    context 'with `help version`' do
      let(:thor_args) { %w[help version] }
      let(:help) do
        <<-EOS
Usage:
  #{command_name} version, -v, --version

Print the version
        EOS
      end

      it_behaves_like 'a `help` command'
    end

    context 'with `help help`' do
      let(:thor_args) { %w[help help] }
      let(:help) do
        <<-EOS
Usage:
  #{command_name} help [COMMAND]

Describe available commands or one specific command
        EOS
      end

      it_behaves_like 'a `help` command'
    end

    context 'with `abc`' do
      let(:thor_args) { %w[abc] }

      it { expect { command }.to output(%(Could not find command "abc".\n)).to_stderr }
    end

    context 'with `helpp`' do
      let(:thor_args) { %w[helpp] }

      if Gem.loaded_specs['thor'].version >= Gem::Version.create('1.0.0') && !Gem.loaded_specs['did_you_mean'].nil? && Gem.loaded_specs['did_you_mean'].version >= Gem::Version.create('1.1.0')
        it { expect { command }.to output(%(Could not find command "helpp".\nDid you mean?  "help"\n)).to_stderr }
      else
        it { expect { command }.to output(%(Could not find command "helpp".\n)).to_stderr }
      end
    end
  end
end
