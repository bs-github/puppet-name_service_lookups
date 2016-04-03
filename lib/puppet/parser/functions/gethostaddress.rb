# encoding: UTF-8

require 'ipaddr'
require 'socket'

module Puppet::Parser::Functions
  newfunction(:gethostaddress, :type => :rvalue, :doc => <<-EOS) do |args|
Looks up a host by address. See `gethostbyname(3)`.

Given a host name as a parameter, it returns its address:
    * name - The host name.

    Returns *undef* if no such host exists.

*Example:*

    gethostaddress('localhost')

Would return:

  '127.0.0.1'

    EOS

    name = args[0]

    begin
      hostent = Socket.gethostbyname(name)
      result  = IPAddr.new_ntoh(hostent[3]).to_s

    rescue SocketError => se
      if se.to_s =~ %r{not known}
        result = :undef
      else
        raise se
      end
    end

    result
  end
end
