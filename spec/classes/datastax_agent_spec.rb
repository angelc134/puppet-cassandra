require 'spec_helper'
describe 'cassandra::datastax_agent' do
  let(:pre_condition) do
    [
      'define ini_setting ($ensure, $path, $section, $key_val_separator, $setting, $value) {}'
    ]
  end

  context 'Test for cassandra::datastax_agent.' do
    it { should have_resource_count(5) }
    it do
      should contain_class('cassandra::datastax_agent').only_with(
        'defaults_file'    => '/etc/default/datastax-agent',
        # 'java_home'       => nil,
        'package_ensure'   => 'present',
        'package_name'     => 'datastax-agent',
        'service_ensure'   => 'running',
        'service_enable'   => true,
        'service_name'     => 'datastax-agent',
        # 'service_provider' => nil,
        'service_systemd'  => false,
        'stomp_interface'  => nil,
        'local_interface'  => nil
      )
    end
    it do
      should contain_package('datastax-agent')
    end
    it do
      should contain_service('datastax-agent')
    end
  end

  context 'Test that agent_alias can be set.' do
    let :params do
      {
        agent_alias: 'node-1'
      }
    end

    it { should contain_ini_setting('agent_alias').with_ensure('present') }
    it do
      should contain_ini_setting('agent_alias').with_value('node-1')
    end
  end

  context 'Test that agent_alias can be ignored.' do
    it do
      should contain_ini_setting('agent_alias').with_ensure('absent')
    end
  end

  context 'Test that stomp_interface can be set.' do
    let :params do
      {
        stomp_interface: '192.168.0.1'
      }
    end

    it { should contain_ini_setting('stomp_interface').with_ensure('present') }
    it do
      should contain_ini_setting('stomp_interface').with_value('192.168.0.1')
    end
  end

  context 'Test that stomp_interface can be ignored.' do
    it do
      should contain_ini_setting('stomp_interface').with_ensure('absent')
    end
  end

  context 'Test that the JAVA_HOME can be set.' do
    let :params do
      {
        java_home: '/usr/lib/jvm/java-8-oracle'
      }
    end

    it do
      should contain_ini_setting('java_home').with(
        'ensure' => 'present',
        'path'   => '/etc/default/datastax-agent',
        'value'  => '/usr/lib/jvm/java-8-oracle'
      )
    end
  end

  context 'Test that local_interface can be set.' do
    let :params do
      {
        local_interface: '127.0.0.1'
      }
    end

    it { should contain_ini_setting('local_interface').with_ensure('present') }
    it do
      should contain_ini_setting('local_interface').with_value('127.0.0.1')
    end
  end

  context 'Test that local_interface can be ignored.' do
    it do
      should contain_ini_setting('local_interface').with_ensure('absent')
    end
  end

  context 'Systemd file can be activated on Red Hat' do
    let :facts do
      {
        osfamily: 'RedHat'
      }
    end

    let :params do
      {
        service_systemd: true
      }
    end

    it { should contain_file('/usr/lib/systemd/system/datastax-agent.service') }
    it { should contain_file('/var/run/datastax-agent') }

    it do 
      is_expected.to contain_exec('/usr/bin/systemctl daemon-reload').with(
        refreshonly: true
      )
    end
  end

  context 'Systemd file can be activated on Debian' do
    let :facts do
      {
        osfamily: 'Debian'
      }
    end

    let :params do
      {
        service_systemd: true
      }
    end

    it { should contain_file('/lib/systemd/system/datastax-agent.service') }
    it { should contain_file('/var/run/datastax-agent') }

    it do 
      is_expected.to contain_exec('/bin/systemctl daemon-reload').with(
        refreshonly: true
      )
    end
  end

  context 'Test that async_pool_size can be set.' do
    let :params do
      {
        async_pool_size: '20000'
      }
    end

    it { should contain_ini_setting('async_pool_size').with_ensure('present') }
    it do
      should contain_ini_setting('async_pool_size').with_value('20000')
    end
  end

  context 'Test that async_queue_size can be set.' do
    let :params do
      {
        async_queue_size: '20000'
      }
    end

    it { should contain_ini_setting('async_queue_size').with_ensure('present') }
    it do
      should contain_ini_setting('async_queue_size').with_value('20000')
    end
  end
end
