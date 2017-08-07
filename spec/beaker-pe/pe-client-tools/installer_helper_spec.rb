require 'spec_helper'

class ClassPEClientToolsMixedWithPatterns
  include Beaker::DSL::InstallUtils::PEClientTools
  include Beaker::DSL::Helpers::HostHelpers
  include Beaker::DSL::Patterns
end

describe ClassPEClientToolsMixedWithPatterns do
  describe "#install_pe_client_tools_on" do
    let(:hosts) do
      make_hosts({:platform => platform })
    end
    let(:opts) do
      {:puppet_collection => 'PC1',
       :pe_client_tools_sha => '12345',
       :pe_client_tools_version => '1.0.0-g12345'}
    end

    let(:tag_opts) do
      {:puppet_collection => 'PC1',
       :pe_client_tools_sha => '56789',
       :pe_client_tools_version => '1.0.0'}
    end

    before do
      allow(subject).to receive(:scp_to)
    end

    context 'on el-6' do
      let(:platform) { Beaker::Platform.new('el-6-x86_64') }
      it 'installs' do
        hosts.each do |host|
          allow(subject). to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{opts[:pe_client_tools_sha]}/repo_configs/rpm/", "pl-pe-client-tools-#{opts[:pe_client_tools_sha]}-repos-pe-el-6-x86_64.repo", "/tmp/repo_configs/el-6-x86_64")
          expect(host).to receive(:install_package).with("pe-client-tools")

          subject.install_pe_client_tools_on(host, opts)
        end
      end

      it 'installs tag versions correctly' do
        hosts.each do |host|
          allow(subject). to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{tag_opts[:pe_client_tools_version]}/repo_configs/rpm/", "pl-pe-client-tools-#{tag_opts[:pe_client_tools_version]}-repos-pe-el-6-x86_64.repo", "/tmp/repo_configs/el-6-x86_64")
          expect(host).to receive(:install_package).with("pe-client-tools")

          subject.install_pe_client_tools_on(host, tag_opts)
        end
      end
    end

    context 'on ubuntu' do
      let(:platform) { Beaker::Platform.new('ubuntu-1604-x86_64') }
      it 'installs' do
        hosts.each do |host|
          allow(subject). to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{opts[:pe_client_tools_sha]}/repo_configs/deb/", "pl-pe-client-tools-#{opts[:pe_client_tools_sha]}-xenial.list", "/tmp/repo_configs/ubuntu-xenial-x86_64")
          expect(subject).to receive(:on).with(host, 'apt-get update')
          expect(host).to receive(:install_package).with('pe-client-tools')

          subject.install_pe_client_tools_on(host, opts)
        end
      end

      it 'installs tag versions correctly' do
        hosts.each do |host|
          allow(subject). to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{tag_opts[:pe_client_tools_version]}/repo_configs/deb/", "pl-pe-client-tools-#{tag_opts[:pe_client_tools_version]}-xenial.list", "/tmp/repo_configs/ubuntu-xenial-x86_64")
          expect(subject).to receive(:on).with(host, 'apt-get update')
          expect(host).to receive(:install_package).with('pe-client-tools')

          subject.install_pe_client_tools_on(host, tag_opts)
        end
      end
    end

    context 'on windows' do
      let(:platform) { Beaker::Platform.new('windows-2012r2-x86_64') }
      it 'installs' do
        hosts.each do |host|
          expect(subject).to receive(:generic_install_msi_on).with( host,
                                                                   "http://builds.delivery.puppetlabs.net/pe-client-tools/#{opts[:pe_client_tools_sha]}/artifacts/windows/pe-client-tools-#{opts[:pe_client_tools_version]}-xx86_64.msi",
                                                                   {},
                                                                   { :debug => true }
                                                                  )
          subject.install_pe_client_tools_on(host, opts)
        end
      end

      it 'installs tag versions correctly' do
        hosts.each do |host|
          expect(subject).to receive(:generic_install_msi_on).with( host,
                                                                   "http://builds.delivery.puppetlabs.net/pe-client-tools/#{tag_opts[:pe_client_tools_version]}/artifacts/windows/pe-client-tools-#{tag_opts[:pe_client_tools_version]}-xx86_64.msi",
                                                                   {},
                                                                   { :debug => true }
                                                                  )
          subject.install_pe_client_tools_on(host, tag_opts)
        end
      end
    end

    context 'on OS X' do
      let(:platform) { Beaker::Platform.new('osx-1111-x86_64') }
      it 'installs' do
        hosts.each do |host|
          allow(subject).to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{opts[:pe_client_tools_sha]}/artifacts/apple/1111/PC1/x86_64", "pe-client-tools-#{opts[:pe_client_tools_version]}-1.osx1111.dmg", "tmp/repo_configs")
          allow(host).to receive(:external_copy_base)
          expect(host).to receive(:generic_install_dmg).with("pe-client-tools-#{opts[:pe_client_tools_version]}-1.osx1111.dmg", "pe-client-tools-#{opts[:pe_client_tools_version]}", "pe-client-tools-#{opts[:pe_client_tools_version]}-1-installer.pkg")
          subject.install_pe_client_tools_on(host, opts)
        end
      end

      it 'installs tag versions correctly' do
        hosts.each do |host|
          allow(subject).to receive(:fetch_http_file).with("http://builds.delivery.puppetlabs.net/pe-client-tools/#{tag_opts[:pe_client_tools_version]}/artifacts/apple/1111/PC1/x86_64", "pe-client-tools-#{tag_opts[:pe_client_tools_version]}-1.osx1111.dmg", "tmp/repo_configs")
          allow(host).to receive(:external_copy_base)
          expect(host).to receive(:generic_install_dmg).with("pe-client-tools-#{tag_opts[:pe_client_tools_version]}-1.osx1111.dmg", "pe-client-tools-#{tag_opts[:pe_client_tools_version]}", "pe-client-tools-#{tag_opts[:pe_client_tools_version]}-1-installer.pkg")

          subject.install_pe_client_tools_on(host, tag_opts)
        end
      end
    end

  end
end
