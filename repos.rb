#!/usr/bin/env ruby

# repos.rb Include your top github repos on your website
# by Ali Craigmile <ali@craigmile.com>

require 'rubygems'
require 'json'
require 'net/http'

GITHUB_USER = 'alicraigmile'
MAX_REPOS_TO_SHOW = 5 # maximum number of repos to show
SORT_BY = 'pushed_at' # one of pushed_at, created_at, updated_at
GITHUB_PREFIX = 'https://github.com/' # URL to use in the 'more like this' like

def get_repos(username)
  url = "https://api.github.com/users/#{username}/repos"
  resp = Net::HTTP.get_response(URI.parse(url))
  data = resp.body

  # we convert the returned JSON data to native Ruby
  # data structure - a hash
  result = JSON.parse(data)

  # if the hash has 'Error' as a key, we raise an error
  if result.has_key? 'Error'
    raise "web service error"
  end
  return result
end

def mock_get_repos(username)
  filename = "mock_repos.json"
  data = File.read(filename)

  result = JSON.parse(data)
  return result
end

github_user = GITHUB_USER
repos = mock_get_repos(github_user)

puts "<div id=\"github-repos\">"

available = repos.count()
showing = available >= MAX_REPOS_TO_SHOW ? MAX_REPOS_TO_SHOW : available
puts "<p>Showing #{showing} of #{available.to_s()} repos.</p>"

puts "<ul>"
repos.sort {|a,b| b[SORT_BY] <=> a[SORT_BY]}.take(showing).each do |repo|
  fmt = '<li><a href="%s">%s</a> – %s</li>'
  puts fmt % [repo['html_url'], repo['full_name'], repo['description']]
end
puts "</ul>"

if (showing < available)
  display_url = "#{GITHUB_PREFIX}#{github_user}".gsub( /https?:\/\//, '' )
  puts "<p>For more like this visit <a href=\"{#GITHUB_PREFIX}#{github_user}\">#{display_url}</a>.</p>"
end

puts "</div>"
