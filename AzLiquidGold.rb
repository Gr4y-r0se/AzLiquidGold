['faraday','erb','json','colorize','optimist'].each(&method(:require))

require_relative 'modules/athena'
require_relative 'modules/vue'
require_relative 'modules/bruteforce'
require_relative 'modules/save'


#Parse commands, and display banner

opts = Optimist::options do
banner File.read('modules/banner.txt')
  opt :help, "Print this help message", :default => false
  opt :target, "Specify the target domain", :type => String
  opt :stop_bruteforce, "Only performs Valid Username Enumeration", :default => false
#  opt :red_team, "Uses the credentials to open SharePoint, Outlook and Azure (if possible)", :default => false
  opt :breach, "Outputs the VUE results as well as the credentail stuffing results", :default => false
  opt :stop_save, "Doesn't save your results", :default => false
  opt :credentials, "Specify the credentials for DeHashed (these will be saved for future use)", :type => String
end

# Ensure mandatory parameters are present and Collisions don't happen 
Optimist::die :credentials, "- Please provide credentials for Dehashed".red if !opts[:credentials] and File.file?('modules/credentials.txt') == false
Optimist::die :target, "- A target domain must be provided with -t".red if !opts[:target]
Optimist::die :stop_bruteforce, "- Cannot use this flag with -b/--breach".red if opts[:stop_bruteforce] and opts[:breach]


if opts[:credentials] then File.write('modules/credentials.txt',opts[:credentials]) end #Saves credentails for further use

data = athena(opts[:target]) #Collect the data

cross_ref = vue(data) #Cross reference the data with Azure 

if opts[:breach] or opts[:stop_bruteforce] then cross_ref.each do |i| puts i end end  #If the user has run the tool in breach mode then output the results of the cross-referencing

if !opts[:stop_bruteforce] then cred_stuff = bruteforce(cross_ref) else cred_stuff = [] end #If the user doesn't want bruteforcing to occur, return an empty array

if !opts[:stop_save] then save(opts[:target],cross_ref,cred_stuff) end #Deals with saving the results

puts "\n\nAzLiquidGold has completed. \n    Accounts Discovered: #{cross_ref.length}\n    Accounts Compromised: #{cred_stuff.length}\n\n".green