#!/usr/bin/env ruby
require 'sinatra'
set :port, 8080
set :bind, '78.46.36.43'

get '/list' do
  status = %x[virsh list --all | awk '!/Id    Name                           State/ && !/----/ '].lines.map(&:chomp)
  status.reject! { |c| c.empty? }
  erb :list, :locals => {:status => status}
end

get '/:name' do |vm|
  status = %x[virsh list --all | awk '/#{vm}/ {print $3," ",$4}']
  if status != ""
    erb :virt, :locals => {:status => status,:vm => vm}
  else
    "<h1><center>This VM Does not Exist</h1></center>"
  end
end

post '/action' do
  if "#{params[:action]}" == "restart"
    %x[virsh destroy #{params[:vm]}]
    %x[virsh start #{params[:vm]}]
  elsif "#{params[:action]}" == "start" || "#{params[:action]}" == "destroy"
    %x[virsh "#{params[:action]}" #{params[:vm]}]
  else
    "Stop trying to be a hacker jimmy, its never gonna happen for you"
    sleep 10
  end
  redirect "/#{params[:vm]}"
end
