#
# Cookbook:: 2_Tomcat
# Recipe:: default
#
# Virtual Hosts Files
# Copyright:: N/A

require 'spec_helper'

describe 'install_apache::default' do
  context 'When all attributes are default, on Rhel 7.5' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'rhel', version: '7.5')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on Suse 12' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'suse', version: '12')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end

  context 'When all attributes are default, on CentOS 7.5' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.5')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
