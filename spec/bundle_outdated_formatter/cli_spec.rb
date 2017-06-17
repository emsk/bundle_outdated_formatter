RSpec.describe BundleOutdatedFormatter::CLI do
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

  let(:stdout_csv) do
    <<-EOS
"gem","newest","installed","requested","groups"
"faker","1.6.6","1.6.5","~> 1.4","development, test"
"hashie","3.4.6","1.2.0","= 1.2.0","default"
"headless","2.3.1","2.2.3","",""
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

  shared_examples_for 'markdown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_markdown).to_stdout }
  end

  shared_examples_for 'json format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_json).to_stdout }
  end

  shared_examples_for 'csv format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.to output(stdout_csv).to_stdout }
  end

  shared_examples_for 'unknown format' do
    before do
      stub_const('STDIN', StringIO.new(stdin))
    end

    it { is_expected.not_to output.to_stdout }
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

    context 'given `output`' do
      let(:thor_args) { %w[output] }
      it_behaves_like 'markdown format'
    end

    context 'given ``' do
      let(:thor_args) { %w[] }
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

    context 'given `output` --format aaa' do
      let(:thor_args) { %w[output --format aaa] }
      it_behaves_like 'unknown format'
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
  -f, [--format=FORMAT]  
                         # Default: markdown

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
