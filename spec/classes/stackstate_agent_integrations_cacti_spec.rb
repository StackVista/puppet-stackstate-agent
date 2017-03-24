require 'spec_helper'

describe 'stackstate_agent::integrations::cacti' do
  let(:facts) {{
    operatingsystem: 'Ubuntu',
  }}
  let(:conf_dir) { '/etc/sts-agent/conf.d' }
  let(:dd_user) { 'sts-agent' }
  let(:dd_group) { 'root' }
  let(:dd_package) { 'stackstate-agent' }
  let(:dd_service) { 'stackstate-agent' }
  let(:conf_file) { "#{conf_dir}/cacti.yaml" }

  context 'with default parameters' do
    it { should compile }
  end

  context 'with parameters set' do
    let(:params) {{
      mysql_host: 'localhost',
      mysql_user: 'foo',
      mysql_password: 'bar',
      rrd_path: 'path',
    }}
    it { should contain_file(conf_file).with_content(/mysql_host: localhost/) }
    it { should contain_file(conf_file).with_content(/mysql_user: foo/) }
    it { should contain_file(conf_file).with_content(/mysql_password: bar/) }
    it { should contain_file(conf_file).with_content(/rrd_path: path/) }
  end
end
