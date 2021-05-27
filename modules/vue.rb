['faraday','json'].each(&method(:require))



def vue(array_) 
	valid_accounts = []
	array_.each do |i|
		resp = Faraday.post('https://login.microsoftonline.com/common/GetCredentialType') do |req|
			req.headers['Content-Type'] = 'application/json'
			req.body = {Username: "#{i.split(':',2)[0]}"}.to_json
		end
		parsed = JSON.parse(resp.body)
		if parsed["IfExistsResult"] === 0 then 
			 valid_accounts.append(i)
		end
	end
	return valid_accounts
end
