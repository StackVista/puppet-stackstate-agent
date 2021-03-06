require 'spec_helper'

describe 'stackstate_agent::integrations::ssh' do
  let(:facts) {{
    operatingsystem: 'Ubuntu',
  }}
  let(:conf_dir) { '/etc/sts-agent/conf.d' }
  let(:dd_user) { 'sts-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'stackstate-agent' }
  let(:dd_service) { 'stackstate-agent' }
  let(:conf_file) { "#{conf_dir}/ssh.yaml" }

  context 'with default parameters' do
    it { should compile }
  end

  context 'with parameters set' do
    let(:params) {{
      host: 'localhost',
      port:  222,
      username: 'foo',
      password: 'bar',
      sftp_check: false,
    }}
    it { should contain_file(conf_file).with_content(/host: localhost/) }
    it { should contain_file(conf_file).with_content(/port: 222/) }
    it { should contain_file(conf_file).with_content(/username: foo/) }
    it { should contain_file(conf_file).with_content(/password: bar/) }
    it { should contain_file(conf_file).without_content(/private_key_file:/) }
  end
end
