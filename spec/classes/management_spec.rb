#!/usr/bin/env rspec

require 'spec_helper'

describe 'scriptura::management' do

  context 'with faulty input' do
    context 'without version' do
      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter version must be provided/
      )}
    end
  end

  context 'with parameters' do
    context 'version => 7.2.6-5.cgk.el6' do
      let (:params) { { :version => '7.2.6-5.cgk.el6' } }

      it { should contain_class('scriptura::management::package').with_version('7.2.6-5.cgk.el6')}

      it { should contain_class('scriptura::management::config') }

      it { should contain_class('scriptura::management::service') }

      it { should contain_class('scriptura::management::package').with_before('Class[Scriptura::Management::Config]') }
      it { should contain_class('scriptura::management::config').with_notify('Class[Scriptura::Management::Service]') }
    end
  end


end
