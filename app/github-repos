#!/usr/bin/env ruby

# repos.rb Include your top github repos on your website
# (c) Ali Craigmile <ali@craigmile.com>

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/..")
require 'bundler/setup'
require 'rubygems'
require 'json'
require 'net/http'
require 'haml'

GITHUB_USER = 'alicraigmile'
MAX_REPOS_TO_SHOW = 5 # maximum number of repos to show
SORT_BY = 'pushed_at' # one of pushed_at, created_at, updated_at
GITHUB_PREFIX = 'https://github.com/' # URL to use in the 'more like this' like
HTML_TEMPLATE = "#{File.dirname(__FILE__)}/../templates/repos.html.haml"
MOCK_FILENAME = "#{File.dirname(__FILE__)}/../mock/mock_repos.json"

def get_repos(username)
  url = "https://api.github.com/users/#{username}/repos"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  # we convert the returned JSON data to native Ruby
  # data structure - a hash
  result = JSON.parse(data)


  # if the hash has 'Error' as a key, we raise an error
  if (! result.kind_of?(Array)) && (result.has_key? 'Error')
    raise "web service error"
  end
  return result
end

def mock_get_repos(username)
  data = File.read(MOCK_FILENAME)

  result = JSON.parse(data)
  return result
end

github_user = GITHUB_USER
#repos = mock_get_repos(github_user)
repos = get_repos(github_user)

# get some nice data ready for the template
available = repos.count()
showing = available >= MAX_REPOS_TO_SHOW ? MAX_REPOS_TO_SHOW : available
show = repos.sort {|a,b| b[SORT_BY] <=> a[SORT_BY]}.take(showing)
github_url = "#{GITHUB_PREFIX}#{github_user}"
display_url = "#{GITHUB_PREFIX}#{github_user}".gsub( /https?:\/\//, '' )

# bundle them all into a managable object to pass to haml
vars = {:available => available, :showing => showing, :show => show, :github_url => github_url, :display_url => display_url};

# render it
engine = Haml::Engine.new(File.read(HTML_TEMPLATE),{:format => :html5})
puts engine.render(Object.new, vars)
