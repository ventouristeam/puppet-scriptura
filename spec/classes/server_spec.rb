#!/usr/bin/env rspec

require 'spec_helper'

describe 'scriptura::server' do

  context 'with faulty input' do
    context 'without version' do
      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter version must be provided/
      )}
    end

    context 'without key_server' do
      let (:params) { { :version => '7.2.6-3.cgk.el6' } }
      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter key_server must be provided/
      )}
    end

    context 'with server_category => foo' do
      let (:params) { { :version => '7.2.6-3.cgk.el6', :key_server => 'foo.example.com', :server_category => 'foo' } }
      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter server_category must be auto, production, backup, test or development/
      )}
    end
  end

  context 'with parameters' do
    context 'version => 7.2.6-3.cgk.el6, key_server => foo.example.com' do
      let (:params) { { :version => '7.2.6-3.cgk.el6', :key_server => 'foo.example.com' } }

      it { should contain_class('scriptura::server::package').with_version('7.2.6-3.cgk.el6')}

      it { should contain_class('scriptura::server::config').with_key_server('foo.example.com') }
      it { should contain_class('scriptura::server::config').with_server_category('production') }

      it { should contain_class('scriptura::server::service') }

      it { should contain_class('scriptura::server::package').with_before('Class[Scriptura::Server::Config]') }
      it { should contain_class('scriptura::server::config').with_notify('Class[Scriptura::Server::Service]') }
    end

    context 'version => 7.2.6-3.cgk.el6, key_server => foo.example.com, server_category => development' do
      let (:params) { { :version => '7.2.6-3.cgk.el6', :key_server => 'foo.example.com', :server_category => 'development' } }

      it { should contain_class('scriptura::server::package').with_version('7.2.6-3.cgk.el6')}

      it { should contain_class('scriptura::server::config').with_key_server('foo.example.com') }
      it { should contain_class('scriptura::server::config').with_server_category('development') }

      it { should contain_class('scriptura::server::service') }

      it { should contain_class('scriptura::server::package').with_before('Class[Scriptura::Server::Config]') }
      it { should contain_class('scriptura::server::config').with_notify('Class[Scriptura::Server::Service]') }
    end
  end

end
