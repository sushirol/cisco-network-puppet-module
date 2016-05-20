require 'rubygems'
require 'json'
require 'cisco_node_utils' if Puppet.features.cisco_node_utils?

Puppet::Type.type(:cisco_yang).provide(:cisco) do
  desc "IOS-XR configuration management via YANG."
  defaultfor operatingsystem: [:ios_xr, :nexus]

  def exists?
    activate
    result = source && source != :absent
#    puts "==== '#{resource_target}' exists? #{result}"
    result
  end

  def create
    setyang(resource_source)
  end

  def destroy
    @source = nil   # clear the cached value
    src = resource_source || resource_target
#    begin
      debug '**************** REMOVING CONFIG ****************'
      #Cisco::Node.instance.setyang(path:  src, action: 'delete_config')
      #CiscoYang::Client.create.setyang(path:  src, action: 'delete_config')
      Cisco::Client.create.setyang(yang_path:  src, action: 'delete_config')
      debug '**************** REMOVE SUCESSFUL ****************'
#    rescue Exception => e
#      puts '**************** ERROR DETECTED WHILE REMOVING CONFIG ****************'
#      puts e.message
#    end
  end

  def resource_target
    @resource[:target]
  end

  def resource_source
    @resource[:source]
  end

  # Return the current source YANG
  def source
    return @source if @source   # return the cached value, if it's there

    #puts "======> retrieving config via GRPC <================="

#    source_yang = CiscoYang::Node.instance.getyang(path: resource_target)
    #source_yang = CiscoYang::Client.create.getyang(path: resource_target)
    source_yang = Cisco::Client.create.getyang(yang_path: resource_target)

    debug '**************** CURRENT CONFIG ****************'
    debug source_yang

    source_yang = :absent if !source_yang || source_yang.empty?

    @source = source_yang
  end

  # Set the source YANG.
  def source=(value)
    setyang(value)
  end

  def setyang(value)
    @source = nil   # clear the cached value
#    begin
      debug '**************** SETTING CONFIG ****************'
      debug value
      #CiscoYang::Node.instance.setyang(path: value, action: 'merge_config')
      #CiscoYang::Client.create.setyang(path: value, action: 'merge_config')
      Cisco::Client.create.setyang(yang_path: value, action: 'merge_config')
      debug '**************** SET SUCESSFUL ****************'
#    rescue Exception => e
#      puts '**************** ERROR DETECTED WHILE APPLYING DESIRED CONFIG ****************'
#      puts e.message
#    end
  end

  def active?
    return @active
  end

  def activate
    @active = true;
  end

  def self.instances
    []
  end
end
