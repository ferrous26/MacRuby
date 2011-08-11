require File.dirname(__FILE__) + "/../spec_helper"

describe 'Module#const_defined?' do

  it 'called on Object will always find Cocoa constants/classes' do
    [:NSString, :NSURL, 'NSDefaultRunLoopMode', 'NSLock'].each do |klass|
      Object.const_defined?(klass).should == true
      Object.const_defined?(klass, true).should == true
      Object.const_defined?(klass, false).should == true
    end
  end

  it 'called on a subclass of Object finds Cocoa constants/classes when recursively searching' do
    [:NSString, :NSURL, 'NSDefaultRunLoopMode', 'NSLock'].each do |klass|
      Module.const_defined?(klass).should == true
      Module.const_defined?(klass, true).should == true
    end
  end

  it 'called on a subclass of Object never finds Cocoa constants/classes when not recursively searching' do
    [:NSString, :NSURL, 'NSDefaultRunLoopMode', 'NSLock'].each do |klass|
      Module.const_defined?(klass, false).should == false
    end
  end

end

describe 'Module#const_get' do

  it 'called on Object will always find Cocoa constants/classes' do
    Object.const_get(:NSString).should == NSString
    Object.const_get(:NSURL, true).should == NSURL
    Object.const_get('NSDefaultRunLoopMode', false).should == NSDefaultRunLoopMode
  end

  it 'called on a subclass of Object finds Cocoa constants/classes when recursively searching' do
    Module.const_get(:NSString).should == NSString
    Module.const_get(:NSURL, true).should == NSURL
  end

  it 'called on a subclass of Object never finds Cocoa constants/classes when not recursively searching' do
    Module.const_get('NSDefaultRunLoopMode', false).should == NSDefaultRunLoopMode
  end

end
