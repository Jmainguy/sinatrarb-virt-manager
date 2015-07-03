#!/usr/bin/env ruby
require 'sinatra'
set :port, 8080
set :bind, '78.46.36.43'


get '/' do
  status = %x[virsh list --all | awk '/centos7.soh.re/ {print $3," ",$4}']
  erb :virt, :locals => {:status => status}
end

post '/' do
  if "#{params[:action]}" == "restart"
    %x[virsh destroy centos7.soh.re]
    %x[virsh start centos7.soh.re]
  elsif "#{params[:action]}" == "start" || "#{params[:action]}" == "destroy"
    %x[virsh "#{params[:action]}" centos7.soh.re]
  else
    "Stop trying to be a hacker jimmy, its never gonna happen for you"
    sleep 10
  end
  redirect "/"
end
