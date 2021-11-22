['faraday','json'].each(&method(:require))



def vue(array_) 
	valid_accounts = []
	array_.each do |i|
		resp = Faraday.post('https://login.microsoftonline.com/common/GetCredentialType') do |req|
			req.headers['Content-Type'] = 'application/json'
			req.body = {Username: "#{i.split(':',2)[0]}"}.to_json
		end
		parsed = JSON.parse(resp.body)
		if [0,5,6].include? parsed["IfExistsResult"] then
			 valid_accounts.append(i)
		end
	end
	return valid_accounts
end
